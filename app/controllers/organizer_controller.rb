class OrganizerController < ApplicationController
  def app
    @center_zip_code = current_community.zip_code.to_s
    @community_id = current_community.id
  end

  def map
    @center_zip_code = current_community.zip_code.to_s
    @community_id = current_community.id
  end

  def add
    cp_client.add_data_point(current_community,params)
    redirect_to :action => :map
  end

end
