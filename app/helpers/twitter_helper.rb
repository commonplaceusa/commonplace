module TwitterHelper

  def twitter_share_url(community)
    url = "http://#{community.slug}.OurCommonPlace.com"
    message = "Hey neighbors! If you live in #{community.name}, check out #{community.name}'s CommonPlace, a new local community bulletin board:"
    
    "http://twitter.com/share?url=#{url}&text=#{message}&count=horizontal"
  end

end
