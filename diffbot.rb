require 'rubygems'
require 'json'
require 'rest-client'
require 'digest/sha1'
require 'mysql2'
require 'active_record'

base_uri = 'http://www.diffbot.com/api/article?'
api_key = 'token=5e916ab6decffc29719f74452eaacb58'
options = '&html=true&tags=true'
url_header = '&url='
article_url = 'http://bits.blogs.nytimes.com/2012/04/02/does-rims-enteprise-plan-herald-more-shrinkage/'

final_uri = base_uri + api_key + options + url_header + article_url

# Use rest-client to make API call (GET)
response = RestClient.get(final_uri)

# Parse JSON into an array.
response_ruby = JSON.parse(response)
# diffbot_url = response_ruby['url']
# diffbot_title = response_ruby['title']
# diffbot_author = response_ruby['author']
# diffbot_date = response_ruby['date']
# diffbot_media = response_ruby['media']
diffbot_text = response_ruby['text']
diffbot_tags = response_ruby['tags']
diffbot_xpath = response_ruby['xpath']
diffbot_html = response_ruby['html']

# puts diffbot_html

=begin
puts response_ruby['url']
puts response_ruby['title']
puts response_ruby['author']
puts response_ruby['date']
puts response_ruby['html']
puts response_ruby['media']
puts response_ruby['text']

puts response_ruby['xpath']
=end

