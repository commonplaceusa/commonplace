authorization do

  role :guest do
    has_permission_on :user_sessions, :to => [:create]
    has_permission_on :accounts, :to => :create
    has_permission_on :site, :to => [:index]
  end

  role :user do
    has_permission_on :site, :to => [:index]
    has_permission_on :user_sessions, :to => [:delete]
    has_permission_on :posts, :to => :create
    has_permission_on :replies, :to => :create
    has_permission_on :accounts, :to => [:show, :update, :delete, :more_info]
  end



end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
