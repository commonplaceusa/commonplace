class ManagementAbility
  include CanCan::Ability
  
  def initialize(user)
    
    can :manage, Organization do |action, org|
      org.admins.include? user
    end

    can :manage, Event do |action, event|
      event.organization.admins.include? user
    end
    
  end
end
