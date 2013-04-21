=begin
Diffbot API Call
1. Retrieve URL from Database
2. Send URL to Diffbot API
3. Get JSON object back
4. Store into Database 
=end
require 'rubygems'
require 'simple-rss'
require 'open-uri'
require 'json'
require 'rest-client'
require 'digest/sha1'
require 'mysql2'
require 'active_record'

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
  base_uri = 'http://www.diffbot.com/api/article?'
  api_key = 'token=5e916ab6decffc29719f74452eaacb58'
  options = '&html=true&tags=true'
  url_header = '&url='
  article_url = url
  final_uri = base_uri + api_key + options + url_header + article_url

  # Make API call.
  response = RestClient.get(final_uri)

  # Parse JSON into an array.
  response_ruby = JSON.parse(response)
  
  return response_ruby
end


def insertResultToDb(result)
  diffbot_result = diffbotCall(result.link)
  Articles.create({
    :section => "Business",
#    :subsection => "", # Could be empty
    :title => result.title,
    :abstract => result.description,
    :url => result.link,   # This is the important URL
    :url_hash => (Digest::SHA1.hexdigest('philip' + result.link)), #Creates/stores Hash
    :byline => diffbot_result['author'],
#    :item_type => result['item_type_type'],
    :source => "Wall Street Journal",
    :updated_date => result.pubDate,
    :created_date => result.pubDate,
    :published_date => result.pubDate,
#    :material_type_facet => result['material_type_facet'],
#    :kicker => result['kicker'], # Could be empty
#    :subheadline => result['subheadline'], # Could be empty
#    :des_facet => result['des_facet'], # Could be array
#    :org_facet => result['org_facet'], # Could be array
#    :per_facet => result['per_facet'], # Could be array, empty
#    :geo_facet => result['geo_facet'], #Could be array
#    :related_urls =>  result['related_urls'], #Could be null, array of text+link
#    :multimedia => result['multimedia'], #Array of pictures
    :article_text => diffbot_result['text'],
    :article_html => diffbot_result['html'],
    :tags => diffbot_result['tags'],
    :xpath => diffbot_result['xpath']})
    puts "Wall Street Journal Business / #{result.title} was updated on: #{result.pubDate}"
end

# DONT FORGET TO CHANGE THE 'SECTION' VALUE ON TOP! # 
# WSJ US Business: http://online.wsj.com/xml/rss/3_7014.xml
rss1 = SimpleRSS.parse open('http://online.wsj.com/xml/rss/3_7014.xml')

# WSJ Health (Business): http://online.wsj.com/xml/rss/3_7089.xml
rss2 = SimpleRSS.parse open('http://online.wsj.com/xml/rss/3_7089.xml')

# WSJ Management (Business): http://online.wsj.com/xml/rss/3_7433.xml
rss3 = SimpleRSS.parse open('http://online.wsj.com/xml/rss/3_7433.xml')

# WSJ Lifestyle: http://online.wsj.com/xml/rss/3_7201.xml
# WSJ US Business: http://online.wsj.com/xml/rss/3_7014.xml
# WSJ Technology: http://online.wsj.com/xml/rss/3_7455.xml
# WSJ Travel: http://online.wsj.com/xml/rss/3_7106.xml
# WSJ Careers: http://online.wsj.com/xml/rss/3_7107.xml
# WSJ U.S. News: http://online.wsj.com/xml/rss/3_8068.xml
# WSJ World News: http://online.wsj.com/xml/rss/3_7085.xml
# WSJ Asia News: http://online.wsj.com/xml/rss/3_7013.xml

=begin
rss.items.each do |result|
  p "This is the title #{result.title}"
  p "Description #{result.description}"
  p "URL: #{result.url}"
  p "Date: #{result.pubDate}"
#  p "This is the link #{i.link}."
end
=end

# Store into DB
rss1.items.each {|article| insertResultToDb(article)}
rss2.items.each {|article| insertResultToDb(article)}
rss3.items.each {|article| insertResultToDb(article)}