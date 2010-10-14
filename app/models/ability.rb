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
      can :create, Announcement
      can :create, Event
      can :update, User
      can :read, User
      can :create, Post
      can :destroy, Post, :user_id => user.id
      can :destroy, UserSession
      can :read, Community
    end

    can :read, Post
    can :read, User
    can :read, Announcement
    can :read, Event
    can :manage, Organization
    can :read, ActsAsTaggableOn::Tag
  end

  

end
