class Thank < ActiveRecord::Base

  belongs_to :user
  belongs_to :thankable, :polymorphic => true

end