# Resources
# http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/MysqlAdapter.html
# http://www.blog.bridgeutopiaweb.com/post/how-to-fix-mysql-load-issues-on-mac-os-x/

require 'rubygems'
require 'mysql2'
require 'active_record'

ActiveRecord::Base.establish_connection ({
:adapter => 'mysql2', 
:host => "host266.hostmonster.com",
:username => "ptwigger_Philip",
:password => "Vokeyoil1!", 
:database => "ptwigger_news"})

class Articles < ActiveRecord::Base
  self.table_name = 'articles'
end

Articles.create({
  :section => "Testing Section",
  :subsection => "",
  :title => "Philip Tests ActiveRecord",
  :abstract => "This is the abstract. This is the abstract. This is the abstract.",
  :url => "www.nytimes.com",
  :byline => "",
  :item_type => "",
  :source => "",
  :updated_date => "",
  :created_date => "2012-03-19T19:35:19-04:00",
  :published_date => "",
  :material_type_facet => "",
  :kicker => "",
  :subheadline => "",
  :des_facet => "",
  :org_facet => "",
  :per_facet => "",
  :geo_facet => "",
  :related_urls => "",
  :multimedia => "",
  :url_hash => Digest::SHA1.hexdigest('philip' + 'www.nytimes.com'),
  :article_text => ""}
  )

p Articles.find(:all)


# BELOW CODE IS NOT USED # 
=begin

dbh = Mysql2::Client.new(:host => "host266.hostmonster.com", :username => "ptwigger_Philip", :password => "Vokeyoil1!", :database => "ptwigger_news")

puts "Server version: " + dbh.get_server_info

dbh.close if dbh

=begin  client = Mysql2::Client.new(:host => "host266.hostmonster.com", :username => "ptwigger_Philip", :password => "Vokeyoil1!", :database => "ptwigger_news")

  test = Article.new();
  test.url = "http://www.newyorktimes.com";
  test.url_hash = "asdfasdfasdfadsfasdfasdfasdf";
  test.created_date = "2012-03-19T19:35:19-04:00";
  testDao = ArticleDao.new(client);
  testDao.insert(test); 

  ensure
    client.close if client
  end
  

#  Article DTO
class Article
  def url; @url; end
  def url_hash; @url_hash; end
  def created_date; @created_date; end
  
  def url=(value) # The setter method for @url
    @url = value
  end
  
  def url_hash=(value)
    @url_hash = value
  end
  
  def created_date=(value)
    @created_date = value
  end
end

#DAO for Article Class
class ArticleDao
  
  def initialize(my)
    @my = my
  end
  
  def insert(dto)
    sql = "INSERT INTO articles (url, url_hash, created_date) VALUES (?, ?, ?)"
    st = @my.prepare(sql)
    st.execute(dto.url, dto.url_hash, dto.name)
    st.close
  end
  
  
end

=end