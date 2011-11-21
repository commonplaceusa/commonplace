class UserAnnouncementsBecomePosts < ActiveRecord::Migration
  def up
    Post.find_each do |post|
      post.update_attribute :category, "neighborhood"
    end
    
    Announcement.select {|a| a.owner_type != "Feed"}.each do |announcement|
      Post.create!(
        :community_id => announcement.community_id,
        :subject => announcement.subject,
        :body => announcement.body,
        :category => "publicity",
        :created_at => announcement.created_at,
        :updated_at => announcement.updated_at,
        :user => announcement.owner,
        :replies => announcement.replies
      )
      announcement.destroy
    end
  end

  def down
    Post.select {|p| p.category == "publicity"}.each do |post|
      Announcement.create!(
        :community_id => post.community_id,
        :subject => post.subject,
        :body => post.body,
        :owner_type => "User",
        :created_at => post.created_at,
        :updated_at => post.updated_at,
        :owner => post.user,
        :replies => post.replies
      )
      post.destroy
    end
  end
end
