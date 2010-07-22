authorization do

  role :guest do
    has_permission_on :user_sessions, :to => [:create]
    has_permission_on :accounts, :to => :create
    has_permission_on :site, :to => [:index]
  end

  role :user do
    has_permission_on :site, :to => [:index]
    has_permission_on :user_sessions, :to => [:delete]
    has_permission_on :posts, :to => [:create, :read]
    has_permission_on :replies, :to => :create
    has_permission_on :accounts, :to => [:show, :update, :delete, :more_info]
    has_permission_on :organizer, :to => [:read]
    has_permission_on :organizer, :to => [:update] do
      if_attribute :admins => includes { user }
    end
    has_permission_on :profiles, :to => [:update] do
      if_attribute :admins => includes { user }
    end
  end



end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
