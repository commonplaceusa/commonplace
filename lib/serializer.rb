module Serializer
  def self.serialize(o, full_dump = false)
    o = o.results if o.respond_to?(:results)
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

      when Thank
        {
          "thanker" => o.user.name,
          "avatar_url" => o.user.avatar_url(:normal),
          "thanker_link" => "/users/#{o.user_id}",
          "thankable_type" => o.thankable_type,
          "thankable_author" => o.thankable.user.name
        }

      when NamedPoint
      {
        "lat" => o.lat,
        "lng" => o.lng,
        "name" => o.name,
        "address" => o.address
      }

      when Resident
        { "first_name" => o.first_name, "last_name" => o.last_name }

      when OrganizerDataPoint
      {
        "address" => o.address,
        "status" => o.status,
        "lat" => o.lat,
        "lng" => o.lng
      }
      when User
        if o.valid?
          o.as_api_response(:default)
        else
          {
            "success" => "false",
            "email" => o.errors["email"],
            "full_name" => o.errors["full_name"],
            "address" => o.errors["address"],
            "password" => o.errors["encrypted_password"],
            "facebook" => o.errors["facebook_uid"]
          }
        end
      when Post
        {
        "id" => o.id,
        "schema" => "posts",
        "avatar_url" => o.user.avatar_url(:thumb),
        "published_at" => o.created_at.utc,
        "url" => "/posts/#{o.id}",
        "title" => o.subject,
        "author" => o.user.name,
        "first_name" => o.user.first_name,
        "body" => o.body,
        "author_url" => "/users/#{o.user_id}",
        "user_id" => o.user_id,
        "replies" => serialize(o.replies.to_a),
        "thanks" => serialize(o.all_thanks.to_a),
        "last_activity" => o.last_activity.utc,
        "category" => o.category,
        "links" => {
          "author" => "/users/#{o.user_id}",
          "replies" => "/posts/#{o.id}/replies",
          "self" => "/posts/#{o.id}",
          "thank" => "/posts/#{o.id}/thank"
        }
      }

      when Event
        {
        "id" => o.id,
        "schema" => "events",
        "published_at" => o.created_at.utc,
        "url" => "/events/#{o.id}",
        "occurs_on" => o.date.to_time.utc,
        "occurs_at" => o.occurs_at.utc.strftime.gsub("+00:00","Z"),
        "date" => o.date.to_time.utc,
        "title" => o.name,
        "author" => o.owner.name,
        "first_name" => o.user.first_name,
        "body" => o.description,
        "tags" => o.tag_list,
        "starts_at" => o.start_time.try(:strftime, "%l:%M%P"),
        "ends_at" => o.end_time.try(:strftime, "%l:%M%P"),
        "venue" => o.venue,
        "address" => o.address,
        "user_id" => o.user_id,
        "feed_id" => o.owner_type == "Feed" ? o.owner_id : nil,
        "feed_url" => o.owner_type == "Feed" ? "/pages/#{o.owner.slug}" : nil,
        "user_url" => o.owner_type == "User" ? "/users/#{o.owner_id}" : nil,
        "owner_type" => o.owner_type,
        "replies" => serialize(o.replies.to_a),
        "thanks" => serialize(o.all_thanks.to_a),
        "links" => {
          "replies" => "/events/#{o.id}/replies",
          "self" => "/events/#{o.id}",
          "author" => "/#{o.owner_type.downcase.pluralize}/#{o.owner_id}",
          "thank" => "/events/#{o.id}/thank"
        }
      }

      when Announcement
        {
        "id" => o.id,
        "schema" => "announcements",
        "url" => "/announcements/#{o.id}",
        "published_at" => o.created_at.utc,
        "avatar_url" => o.owner.avatar_url(:thumb),
        "author_url" => "/#{o.owner_type.downcase.pluralize}/#{o.owner_id}",
        "author" => o.owner.name,
        "first_name" => o.user.first_name,
        "user_id" => o.user_id,
        "feed_id" => o.owner_type == "Feed" ? o.owner_id : nil,
        "feed_url" => o.owner_type == "Feed" ? "/pages/#{o.owner.slug}" : nil,
        "user_url" => o.owner_type == "User" ? "/users/#{o.owner_id}" : nil,
        "title" => o.subject,
        "body" => o.body,
        "owner_type" => o.owner_type,
        "replies" => serialize(o.replies.to_a),
        "thanks" => serialize(o.all_thanks.to_a),
        "links" => {
          "replies" => "/announcements/#{o.id}/replies",
          "self" => "/announcements/#{o.id}",
          "author" => "/#{o.owner_type.downcase.pluralize}/#{o.owner_id}",
          "thank" => "/announcements/#{o.id}/thank"
        }
      }

      when GroupPost
        {
        "id" => o.id,
        "schema" => "group_posts",
        "url" => "/group_posts/#{o.id}",
        "published_at" => o.created_at.utc,
        "author" => o.user.name,
        "first_name" => o.user.first_name,
        "avatar_url" => o.group.avatar_url(:thumb),
        "author_url" => "/users/#{o.user_id}",
        "group" => o.group.name,
        "group_url" => "/groups/#{o.group_id}",
        "user_id" => o.user_id,
        "group_id" => o.group_id,
        "title" => o.subject,
        "body" => o.body,
        "replies" => serialize(o.replies.to_a),
        "thanks" => serialize(o.all_thanks.to_a),
        "links" => {
          "replies" => "/group_posts/#{o.id}/replies",
          "author" => "/users/#{o.user_id}",
          "group" => "/groups/#{o.group_id}",
          "self" => "/group_posts/#{o.id}",
          "thank" => "/group_posts/#{o.id}/thank"
        }
        }

      when Message
        {
        "id" => o.id,
        "schema" => "messages",
        "type" => o.messagable_type,
        "url" => "/users/#{o.messagable_id}/messages/#{o.id}",
        "published_at" => o.created_at.utc,
        "user_id" => o.messagable_id,
        "user" => o.messagable.name,
        "author_id" => o.user_id,
        "avatar_url" => o.user.avatar_url(:thumb),
        "author" => o.user.name,
        "title" => o.subject,
        "body" => o.body,
        "replies" => serialize(o.replies.to_a),
        "links" => {
          "replies" => "/messages/#{o.id}/replies",
          "author" => "/users/#{o.user_id}",
          "self" => "/messages/#{o.id}",
          "user" => (o.messagable_type == "User" ? "/users" : "/feeds") + "/#{o.messagable_id}"
        }
        }

      when Reply
        {
        "id" => o.id,
        "schema" => "replies",
        "author" => o.user.name,
        "avatar_url" => o.user.avatar_url(:thumb),
        "author_url" => "/users/#{o.user_id}",
        "author_id" => o.user.id,
        "body" => o.body,
        "published_at" => o.created_at.utc,
        "thanks" => serialize(o.thanks.to_a),
        "links" => {
          "author" => "/users/#{o.user_id}",
          "self" => "/replies/#{o.id}",
          "thank" => "/replies/#{o.id}/thank"
        }
        }

      when Feed
        o.as_api_response(:default)
      when FeedOwner
        {
        "id" => o.id,
        "user_id" => o.user_id,
        "feed_id" => o.feed_id,
        "user_name" => o.user.name,
        "user_email" => o.user.email,
        "links" => {
          "self" => "/feeds/#{o.feed_id}/owners/#{o.id}",
          "user" => "/users/#{o.user_id}",
          "feed" => "/feeds/#{o.feed_id}"
        }
      }

      when Group
        o.as_api_response(:default)
      when Account
        {
        "id" => o.id,
        "schema" => "account",
        "avatar_url" => o.avatar_url(:normal),
        "avatar_original" => o.avatar_url(:original),
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
        "goods" => o.good_list,
        "skills" => o.skill_list,
        "subscriptions" => o.feeds,
        "neighborhood_posts" => o.post_receive_method,
        "bulletin" => o.receive_weekly_digest,
        "post_count" => o.posts.count,
        "reply_count" => o.replies.count,
        "about" => o.about,
        "links" => {
          "avatar" => "/account/avatar",
          "crop" => "/account/crop",
          "feed_subscriptions" => "/account/subscriptions/feeds",
          "group_subscriptions" => "/account/subscriptions/groups",
          "mets" => "/account/mets",
          "self" => "/account",
          "edit" => "/account/profile",
          "inbox" => "/account/inbox",
          "sent" => "/account/inbox/sent",
          "feed_messages" => "/account/inbox/feeds",
          "neighborhoods_posts" => "/neighborhoods/#{o.neighborhood_id}/posts",
          "featured_users" => "/account/featured",
          "neighbors" => "/account/neighbors"
        },
        "metadata" => o.metadata,
        "history" => o.profile_history,
        "current_sign_in_ip" => o.current_sign_in_ip
        }

      when Community
        o.as_api_response(:default)
      when CommunityWire
        { "events" => serialize(o.events),
        "neighborhood" => serialize(o.neighborhood),
        "offers" => serialize(o.offers),
        "help" => serialize(o.help),
        "publicity" => serialize(o.publicity),
        "group" => serialize(o.group),
        "other" => serialize(o.other),
        "meetups" => serialize(o.meetups)
      }

      when CommunityExterior
        o.as_api_response(:default)

      end

    as_json
  end
end

