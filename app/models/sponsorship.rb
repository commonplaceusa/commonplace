class Sponsorship < ActiveRecord::Base

  belongs_to :event
  
  belongs_to :sponsor, :polymorphic => true
  belongs_to :business, :class_name => "Business",
                        :foreign_key => "sponsor_id"
  belongs_to :organization, :class_name => "Organization",
                            :foreign_key => "sponsor_id"



end
