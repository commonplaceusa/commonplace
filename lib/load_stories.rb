require 'rubygems'
require 'json'
require 'digest/md5'
require 'net/http'
require 'uri'
#require 'pismo'

class LoadStories
  BASE_URL = "http://news-api.patch.com/v1.1"
  @queue = :daily_new_stories
  
  def self.perform
    User.create!(:first_name => "tryagain", :last_name => "dev",:email => "try@example.com", :address => "221B Baker St.",:password => "password",:community => Community.find(17))
    l=LoadStories.new
    l.init_communities_last_story
    l.load_stories
  end
  
  def find_stories(state,city,page)
    url="/states/#{URI.escape(state.downcase)}/cities/#{URI.escape(city.downcase)}/stories"
    request(url,page) do |response|
      JSON[response.body]
    end
  end

  def request(path,page, &block)
    #url = URI.parse(sign("#{BASE_URL}#{path}")+"&keyword="+self.first_name+"%20"+self.last_name)
    url = URI.parse(sign("#{BASE_URL}#{path}",page))
    puts "Requesting #{url}"
    response = Net::HTTP.get_response(url)
    if response.code.to_i == 200
      yield(response)
    else
      #raise Exception.new("Request failed with code #{response.code}")
      "#{response.code}"
    end
  end

  def sign(url,page)
    @key = '3h3n5k5j8375trecsr6x9enc'
    @secret = 'TM9xkeYa9U'
    "#{url}?page=#{page}&dev_key=#{@key}&sig=#{Digest::MD5.hexdigest(@key + @secret + Time.now.to_i.to_s)}"
  end

  def create_stories(stories,c)
    over=true
    if stories
      stories.each do |story|
        if story['story_url']!=c.last_story
          #doc = Pismo::Document.new(story['story_url'])
          url="http://viewtext.org/api/text?url="+story['story_url']+"&format=JSON"
          response = Net::HTTP.get_response(URI(url))
          puts story['story_url']
          c.stories.create(:title=>story['title'],:url=>story['story_url'],:summary=>story['summary'],:content=>JSON[response.body]['content'])
        else
          over=false
          break
        end
      end
    end
    over
  end
  
  def find_story(c)
    #Story.delete_all(:community_id=>self.id)
    page=1
    data=find_stories(c.state,c.name,page)
    if data.class.name!="String"
    if data['stories'].size>0
      last_story=data['stories'][0]['story_url']
      over=create_stories(data['stories'],c)
      while over do
        page=page+1
        data=find_stories(c.state,c.name,page)
        over=create_stories(data['stories'],c)
      end
    end
    c.last_story=last_story
    c.save
    end
=begin
    if data['total']>0
      self.last_story_time=data['stories'][0]['published_at']
    end
=end
    #data['stories']
    page
  end
  
  def init_last_story(c)
    if c.last_story==nil
      if find_stories(c.state,c.name,1)['stories']
        size=find_stories(c.state,c.name,1)['stories'].size
        c.last_story=find_stories(c.state,c.name,1)['stories'][size-1]['story_url'] if size>0
        c.save
      end
    end
  end
  
  def load_stories
    count=0
    Community.all.each do |c|
      count=count+1
      sleep(1) if count%3==0
      puts c.id
      find_story(c) if c.state && c.last_story
    end
    count
  end
  
  def load_community_stories(c)
    find_story(c)
  end
  
  def init_communities_last_story
    count=0
    Community.all.each do |c|
      count=count+1
      sleep(1) if count%3==0
      init_last_story(c) if c.state && c.last_story
    end
  end  
  
  def init_community_last_story(c)
    init_last_story(c)
  end

end
