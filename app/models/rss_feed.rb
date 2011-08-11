class RssFeed < Feed
  
  validates_uniqueness_of :feed_url
  
  after_create :find_avatar
  
  def find_avatar
    # Pull the favicon
    require 'open-uri'
    begin
      f = open(self.website)
    rescue
      err = $!.to_s
    end
    if !err
      a = f.read
      s = a.slice(/link.*rel\=.*shortcut.*\"/)
      if s != nil
        exp = s.split("href=")
        exp1 = exp[1].split('"')
        exp2 = exp1[1].split("http:")
        if exp2[0] != ""
          self.avatar_file_name = main_url+exp1[1]
        else
          self.avatar_file_name = exp1[1]
        end
      else
        self.avatar_file_name = self.website + "/favicon.ico"
      end
      self.save
    end
    
  end
  
  def profile_link
    return "/feeds/" + self.owner_id
  end
  
end
