class Ability
  include CanCan::Ability
  
  
  def initialize(user)

    alias_action :_form, :to => :create
    alias_action(:neighborhood, :subscribed, :your, :suggested, :neighbors,
                 :business, :municipal,
                 :to => :read)
    if user.new_record?
      can :create, User
      can :create, UserSession
    else
      can :read, Message do |m|
        m.user == user || m.messagable == user
      end
      can :create, Announcement
      can :create, Event
      can :update, User
      can :read, User
      can :create, Post
      can :destroy, Post, :user_id => user.id
      can :update, Post, :user_id => user.id
      can :create, GroupPost
      can :destroy, GroupPost, :user_id => user.id
      can :update, GroupPost, :user_id => user.id
      can :destroy, UserSession
      can :read, Reply
      can :create, Reply
      can :read, Post
      can :read, GroupPost
      can :read, User
      can :read, Announcement
      can :read, Event
      can :read, Feed
      can :profile, Feed
      can :create, Feed
      can :manage, Feed, :user_id => user.id
      
      can :manage, Event do |e|
        e.user == user
      end
      
      can :manage, Announcement do |a|
        case a.owner
        when Feed then a.owner.user_id == user.id
        when User then a.owner.id == user.id
        else false
        end
      end

      if user.admin?
        can :uplift, Post
        can :destroy, Post
      end
      
    end
      can :read, Community
  end

  

end
