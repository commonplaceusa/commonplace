module Serializer
  def self.serialize(o)
    as_json = 
      case o
        
      when String
        o

      when Array
        o.map {|t| serialize t }
        
      when User
        { "id" => o.id,
        "avatar_url" => o.avatar_url(:normal),
        "url" => "/users/#{o.id}",
        "name" => o.name,
        "first_name" => o.first_name,
        "last_name" => o.last_name,
        "about" => o.about,
        "interests" => o.interest_list,
        "offers" => o.offer_list,
        "subscriptions" => o.feed_list }
        
      when Post
        { 
        "id" => o.id,
        "avatar_url" => o.user.avatar_url(:thumb),
        "published_at" => o.created_at.utc,
        "url" => "/posts/#{o.id}",
        "title" => o.subject,
        "author" => o.user.name,
        "body" => o.body,
        "author_url" => "/users/#{o.user_id}",
        "replies" => serialize(o.replies.to_a),
        "last_activity" => o.last_activity.utc }

      when Event
        { 
        "id" => o.id,
        "published_at" => o.created_at.utc,
        "url" => "/events/#{o.id}",
        "occurs_on" => o.date.to_time.utc,
        "occurs_at" => o.occurs_at.utc.strftime.gsub("+00:00","Z"),
        "title" => o.name,
        "author" => o.owner.name,
        "body" => o.description,
        "author_url" => "/#{o.owner_type.downcase.pluralize}/#{o.owner_id}",
        "messagable_author_url" => (o.owner_type.downcase == "feed") ? "/feeds/#{o.owner_id}/#{o.owner.user_id}" : "/users/#{o.owner_id}",
        "messagable_author_name" => (o.owner_type.downcase == "feed") ? o.owner.name : o.owner.first_name,
        "tags" => o.tag_list,
        "starts_at" => o.start_time.try(:strftime, "%l:%M%P"),
        "ends_at" => o.end_time.try(:strftime, "%l:%M%P"),
        "venue" => o.venue,
        "address" => o.address,
        "user_id" => o.owner_type == "User" ? o.owner_id : nil,
        "feed_id" => o.owner_type == "Feed" ? o.owner_id : nil,
        "replies" => serialize(o.replies.to_a),
        "links" => {
          "replies" => "/events/#{o.id}/replies",
          "self" => "/events/#{o.id}"
        }
      }

      when Announcement
        { 
        "id" => o.id,
        "url" => "/announcements/#{o.id}",
        "published_at" => o.created_at.utc,
        "avatar_url" => o.owner.avatar_url(:thumb),
        "author_url" => "/#{o.owner_type.downcase.pluralize}/#{o.owner_id}",
        "author" => o.owner.name,
        "user_id" => o.owner_type == "User" ? o.owner_id : nil,
        "feed_id" => o.owner_type == "Feed" ? o.owner_id : nil,
        "title" => o.subject,
        "body" => o.body,
        "replies" => serialize(o.replies.to_a),
        "links" => {
          "replies" => "/announcements/#{o.id}/replies",
          "self" => "/announcements/#{o.id}"
        } 
      }

      when GroupPost
        { 
        "id" => o.id,
        "url" => "/group_posts/#{o.id}",
        "published_at" => o.created_at.utc,
        "author" => o.user.name,
        "avatar_url" => o.group.avatar_url(:thumb),
        "author_url" => "/users/#{o.user_id}",
        "group" => o.group.name,
        "group_url" => "/groups/#{o.group_id}",
        "user_id" => o.user_id,
        "group_id" => o.group_id,
        "title" => o.subject,
        "body" => o.body,
        "replies" => serialize(o.replies.to_a) }

      when Reply
        { 
        "author" => o.user.name,
        "avatar_url" => o.user.avatar_url(:thumb),
        "author_url" => "/users/#{o.user_id}",
        "body" => o.body,
        "published_at" => o.created_at.utc }

      when Feed
        { 
        "id" => o.id,
        "user_id" => o.user.id,
        "url" => "/feeds/#{o.id}",
        "slug" => o.slug.blank? ? o.id : o.slug ,
        "name" => o.name,
        "about" => o.about,
        "avatar_url" => o.avatar_url(:normal),
        "profile_url" => "/feeds/#{o.id}/profile",
        "tags" => o.tag_list,
        "website" => o.website,
        "phone" => o.phone,
        "address" => o.address,
        "links" => { 
          "avatar" => {
            "large" => o.avatar_url(:large),
            "normal" => o.avatar_url(:normal),
            "thumb" => o.avatar_url(:thumb)
          },
          "announcements" => "/feeds/#{o.id}/announcements",
          "events" => "/feeds/#{o.id}/events",
          "invites" => "/feeds/#{o.id}/invites",
          "messages" => "/feeds/#{o.id}/messages",
          "edit" => "/feeds/#{o.id}/edit"
        },
        "messagable_author_url" => "/feeds/#{o.id}/#{o.user.id}",
      "messagable_author_name" => o.name
      }

      when Group
        { 
        "id" => o.id,
        "url" => "/groups/#{o.id}",
        "name" => o.name,
        "about" => o.about,
        "avatar_url" => o.avatar_url }

      when Account
        {
        "id" => o.id,
        "avatar_url" => o.avatar_url(:normal),
        "feed_subscriptions" => o.feed_subscriptions,
        "group_subscriptions" => o.group_subscriptions,
        "is_admin" => o.is_admin,
        "accounts" => o.accounts.map {|a| {:name => a.name, :uid => "#{a.class.name.underscore}_#{a.id}"} },
        "short_name" => o.short_name,
        "email" => o.email,
        "posts" => o.posts,
        "events" => o.events,
        "announcements" => o.announcements,
        "group_posts" => o.group_posts,
        "neighborhood" => o.neighborhood, 
        "links" => { 
          "feed_subscriptions" => "/account/subscriptions/feeds"
        }
        }

      when Community
        community_asset_url = "https://s3.amazonaws.com/commonplace-community-assets/#{o.slug}/"
        { 
        "id" => o.id,
        "slug" => o.slug,
        "name" => o.name,
        "links" => {
          "launch_letter" => community_asset_url + "launchletter.pdf",
          "information_sheet" => community_asset_url + "infosheet.pdf",
          "neighborhood_flyer" => community_asset_url + "neighborflyer.pdf",
          "all_flyers" => community_asset_url + "archives.zip",
          "groups" => "/communities/#{o.id}/groups",
          "feeds" => "/communities/#{o.id}/feeds"
          
        }
      }
      end

    as_json
  end
end

