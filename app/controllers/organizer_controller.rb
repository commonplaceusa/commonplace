class OrganizerController < ApplicationController
  def app
    @center_zip_code = current_community.zip_code.to_s
    @community_id = current_community.id
  end

  def add
    puts "(1..#{params[:entry_count]})"
    (1..(params[:entry_count].to_i)).each do |e|
      cp_client.add_data_point(current_community, {:number => params["number_#{e}"], :address => params["address_#{e}"]})
    end
    redirect_to :action => :app
  end

end
