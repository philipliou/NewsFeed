=begin
Diffbot API Call
1. Retrieve URL from Database
2. Send URL to Diffbot API
3. Get JSON object back
4. Store into Database 
=end
require 'rubygems'
require 'json'
require 'rest-client'
require 'digest/sha1'
require 'mysql2'
require 'active_record'

# Parameters for API URI
# API call format: http://api.nytimes.com/svc/news/{version}/content/{source}/{section}[/time-period][.response-format]?api-key={your-API-key}
# My call: http://api.nytimes.com/svc/news/v3/content/nyt/all?api-key=6f03680ab6594ff84c4c3ab231218048:11:58916261

base_uri = 'http://api.nytimes.com/svc/news/'
nyt_version = 'v3/content/'
nyt_source = 'nyt/'
nyt_section = 'all'
api_key = '?api-key=6f03680ab6594ff84c4c3ab231218048:11:58916261'

final_uri = base_uri + nyt_version + nyt_source + nyt_section + api_key

# Use rest-client to make API call (GET)
response = RestClient.get(final_uri)

=begin DETAILS ABOUT RESPONSE 
1. response.args contains: {:method=>:get, :url=>"http://api.nytimes.com/svc/news/v3/content/nyt/all?api-key=6f03680ab6594ff84c4c3ab231218048:11:58916261", :headers=>{}}
2. response.body is the actual JSON object: {"status":"OK"....."results":[{"section..."}]}
3. response.net_http_res includes HTTP header.
=end

# Parse JSON into an array and store each article into mySQL DB.
response_ruby = JSON.parse(response)
results = response_ruby["results"]

# But first, prepare connection to DB
ActiveRecord::Base.establish_connection({
:adapter => 'mysql2', 
:host => "localhost",
:username => "ptwigger_Philip",
:password => "Vokeyoil1!", 
:database => "ptwigger_news"})

class Articles < ActiveRecord::Base
  self.table_name = 'articles'
  
  validates_uniqueness_of :url_hash
end

def diffbotCall(url)
  # 1. Prepare parameters
  base_uri = 'http://www.diffbot.com/api/article?'
  api_key = 'token=5e916ab6decffc29719f74452eaacb58'
  options = '&html=true&tags=true'
  url_header = '&url='
  article_url = url
  final_uri = base_uri + api_key + options + url_header + article_url

  # 2. Make API call.
  response = RestClient.get(final_uri)

  # 3. Parse JSON into an array.
  response_ruby = JSON.parse(response)
  
  # 4. Return
  return response_ruby
end


def insertResultToDb (result)
  hash = Digest::SHA1.hexdigest('philip' + result['url'])
  # Below code checks for duplicates based on url_hash before making Diffbot call. 
  article = Articles.first(:conditions => ["url_hash = '#{hash}'"])
 # puts "This is the title" + article.title
  if(! article)
    puts "The article was not found"
    diffbot_result = diffbotCall(result['url'])
    Articles.create({
      :section => result['section'],
      :subsection => result['subsection'], # Could be empty
      :title => result['title'],
      :abstract => result['abstract'],
      :url => result['url'],   # This is the important URL
      :url_hash => (Digest::SHA1.hexdigest('philip' + result['url'])), #Creates/stores Hash
      :byline => result['byline'],
      :item_type => result['item_type_type'],
      :source => result['source'],
      :updated_date => result['updated_date'],
      :created_date => result['created_date'],
      :published_date => result['published_date'],
      :material_type_facet => result['material_type_facet'],
      :kicker => result['kicker'], # Could be empty
      :subheadline => result['subheadline'], # Could be empty
      :des_facet => result['des_facet'], # Could be array
      :org_facet => result['org_facet'], # Could be array
      :per_facet => result['per_facet'], # Could be array, empty
      :geo_facet => result['geo_facet'], #Could be array
      :related_urls =>  result['related_urls'], #Could be null, array of text+link
      :multimedia => result['multimedia'], #Array of pictures
      :article_text => diffbot_result['text'],
      :article_html => diffbot_result['html'],
      :tags => diffbot_result['tags'],
      :xpath => diffbot_result['xpath']})
  #  else
      puts "#{(Digest::SHA1.hexdigest('philip' + result['url']))}"
      puts "#{result['title']}"
      puts "#{result['updated_date']}"
  else
  end
end

# Store Ruby structure into DB
results.each {|article| insertResultToDb(article)}

# Retrieve articles from NYT (using Article Search API) http://developer.nytimes.com/docs/article_search_api
