module Serializer
  def self.serialize(o)
    o = o.to_a if o.respond_to?(:to_a)
    as_json = 
      case o
        
      when String
        o

      when Fixnum
        o.to_s

      when Float
        o.to_s

      when Array
        o.map {|t| serialize t }

      when NamedPoint
      {
        "lat" => o.lat,
        "lng" => o.lng,
        "name" => o.name
      }

      when OrganizerDataPoint
      {
        "address" => o.address,
        "status" => o.status,
        "lat" => o.lat,
        "lng" => o.lng
      }
      when User
        { "id" => o.id,
        "schema" => "user",
        "avatar_url" => o.avatar_url(:normal),
        "url" => "/users/#{o.id}",
        "name" => o.name,
        "first_name" => o.first_name,
        "last_name" => o.last_name,
        "about" => o.about,
        "interests" => o.interest_list,
        "offers" => o.offer_list,
        "subscriptions" => o.feed_list,
        "links" => {
          "messages" => "/people/#{o.id}/messages",
          "self" => "/users/#{o.id}"
        }
      }
      when Post
        { 
        "id" => o.id,
        "schema" => "post",
        "avatar_url" => o.user.avatar_url(:thumb),
        "published_at" => o.created_at.utc,
        "url" => "/posts/#{o.id}",
        "title" => o.subject,
        "author" => o.user.name,
        "body" => o.body,
        "author_url" => "/users/#{o.user_id}",
        "user_id" => o.user_id,
        "replies" => serialize(o.replies.to_a),
        "last_activity" => o.last_activity.utc,
        "links" => {
          "author" => "/users/#{o.user_id}",
          "replies" => "/posts/#{o.id}/replies",
          "self" => "/posts/#{o.id}"
        }
      }

      when Event
        { 
        "id" => o.id,
        "schema" => "event",
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
        "user_id" => o.user_id,
        "feed_id" => o.owner_type == "Feed" ? o.owner_id : nil,
        "owner_type" => o.owner_type,
        "replies" => serialize(o.replies.to_a),
        "links" => {
          "replies" => "/events/#{o.id}/replies",
          "self" => "/events/#{o.id}",
          "author" => "/#{o.owner_type.downcase.pluralize}/#{o.owner_id}"
        }
      }

      when Announcement
        { 
        "id" => o.id,
        "schema" => "announcement",
        "url" => "/announcements/#{o.id}",
        "published_at" => o.created_at.utc,
        "avatar_url" => o.owner.avatar_url(:thumb),
        "author_url" => "/#{o.owner_type.downcase.pluralize}/#{o.owner_id}",
        "author" => o.owner.name,
        "user_id" => o.user_id,
        "feed_id" => o.owner_type == "Feed" ? o.owner_id : nil,
        "title" => o.subject,
        "body" => o.body,
        "owner_type" => o.owner_type,
        "replies" => serialize(o.replies.to_a),
        "links" => {
          "replies" => "/announcements/#{o.id}/replies",
          "self" => "/announcements/#{o.id}",
          "author" => "/#{o.owner_type.downcase.pluralize}/#{o.owner_id}"
        }

      }

      when GroupPost
        { 
        "id" => o.id,
        "schema" => "group_post",
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
        "replies" => serialize(o.replies.to_a),
        "links" => {
          "replies" => "/group_posts/#{o.id}/replies",
          "author" => "/users/#{o.user_id}",
          "group" => "/groups/#{o.group_id}",
          "self" => "/group_posts/#{o.id}"
        }
        }

      when Reply
        { 
        "schema" => "reply",
        "author" => o.user.name,
        "avatar_url" => o.user.avatar_url(:thumb),
        "author_url" => "/users/#{o.user_id}",
        "body" => o.body,
        "published_at" => o.created_at.utc,
        "links" => {
          "author" => "/users/#{o.user_id}"
        }
        }

      when Feed
        { 
        "id" => o.id,
        "schema" => "feed",
        "user_id" => o.user.id,
        "url" => "/pages/#{o.slug}",
        "slug" => o.slug ,
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
          "edit" => "/feeds/#{o.id}/edit",
          "subscribers" => "/feeds/#{o.id}/subscribers",
          "self" => "/feeds/#{o.id}"
        },
        "messagable_author_url" => "/feeds/#{o.id}/#{o.user.id}",
      "messagable_author_name" => o.name
      }

      when Group
        { 
        "id" => o.id,
        "schema" => "group",
        "url" => "/groups/#{o.id}",
        "name" => o.name,
        "about" => o.about,
        "avatar_url" => o.avatar_url,
        "slug" => o.slug,
        "links" => {
          "posts" => "/groups/#{o.id}/posts",
          "members" => "/groups/#{o.id}/members",
          "announcements" => "/groups/#{o.id}/announcements",
          "events" => "/groups/#{o.id}/events",
          "self" => "/groups/#{o.id}"
        }
        }

      when Account
        {
        "id" => o.id,
        "schema" => "account",
        "avatar_url" => o.avatar_url(:normal),
        "feed_subscriptions" => o.feed_subscriptions,
        "group_subscriptions" => o.group_subscriptions,
        "is_admin" => o.is_admin,
        "accounts" => o.accounts.map {|a| {:name => a.name, :uid => "#{a.class.name.underscore}_#{a.id}"} },
        "short_name" => o.short_name,
        "name" => o.full_name,
        "email" => o.email,
        "posts" => o.posts,
        "events" => o.events,
        "feeds" => o.feeds,
        "mets" => o.mets,
        "announcements" => o.announcements,
        "group_posts" => o.group_posts,
        "neighborhood" => o.neighborhood, 
        "interests" => o.interest_list,
        "offers" => o.offer_list,
        "subscriptions" => o.feed_list,
        "about" => o.about,
        "links" => { 
          "feed_subscriptions" => "/account/subscriptions/feeds",
          "group_subscriptions" => "/account/subscriptions/groups",
          "mets" => "/account/mets",
          "self" => "/account",
          "edit" => "/account/profile"
        }
        }

      when Community
        community_asset_url = "https://s3.amazonaws.com/commonplace-community-assets/#{o.slug}/"
        { 
        "id" => o.id,
        "schema" => "community",
        "slug" => o.slug,
        "name" => o.name,
        "groups" => o.groups.map {|g| 
          { "avatar_url" => g.avatar_url, "id" => g.id, "name" => g.name }
        },
        "locale" => o.locale.to_s,
        "links" => {
          "launch_letter" => community_asset_url + "launchletter.pdf",
          "information_sheet" => community_asset_url + "infosheet.pdf",
          "neighborhood_flyer" => community_asset_url + "neighborflyer.pdf",
          "all_flyers" => community_asset_url + "archives.zip",
          "groups" => "/communities/#{o.id}/groups",
          "feeds" => "/communities/#{o.id}/feeds",
          "posts" => "/communities/#{o.id}/posts",
          "events" => "/communities/#{o.id}/events",
          "announcements" => "/communities/#{o.id}/announcements",
          "group_posts" => "/communities/#{o.id}/group_posts",
          "users" => "/communities/#{o.id}/users",
          "self" => "/communities/#{o.id}"
        }
      }
      end

    as_json
  end
end

