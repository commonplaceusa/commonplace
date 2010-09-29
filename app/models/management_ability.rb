class ManagementAbility
  include CanCan::Ability
  
  def initialize(user)
    if user.new_record?
    else
      can :manage, Organization do |action, org|
        org.admins.include? user
      end
      
      can :manage, Event do |action, event|
        event.organization.admins.include? user
      end
      
      can :read, :management
    end
  end
end
