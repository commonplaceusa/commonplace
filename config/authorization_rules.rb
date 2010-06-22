authorization do

  role :guest do
    has_permission_on :user_sessions, :to => [:create]
    has_permission_on :accounts, :to => :create
  end

  role :user do
    has_permission_on :user_sessions, :to => [:delete]
  end



end


privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
