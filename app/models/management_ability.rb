class ManagementAbility
  include CanCan::Ability
  
  def initialize(user)
    if user.new_record?
    else
      can :manage, Feed do |action, feed|
        feed.user == user
      end
      
      can :manage, Event do |action, event|
        event.owner.is_a?(User) ? event.owner == user : event.owner.user == user
      end
      
      can :read, :management
    end
  end
end
