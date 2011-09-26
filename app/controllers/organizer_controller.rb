class OrganizerController < ApplicationController
  def map
    @addresses = current_community.users.map &:address
    @data_points = current_community.organizers.map(&:organizer_data_points).flatten.select { |p| p.present? }
    @center_zip_code = current_community.zip_code.to_s
    @community_bias = "Falls Church, VA"
    @community_id = current_community.id
  end

  def add
    @data_point = OrganizerDataPoint.new
    @data_point.organizer_id = current_user.id

    num = params[:number]
    if num.include? "-"
      # Needs to be parsed
      odds = false
      evens = false
      all = true

      if num.include? "O"
        puts "Odd"
        odds = true
        all = false
        num = num.gsub("O", "")
      elsif num.include? "E"
        puts "Even"
        evens = true
        all = false
        num = num.gsub("E", "")
      end

      range = num.split("-")
      (range[0].to_i..range[1].to_i).each do |n|
        if (odds and (n % 2 == 1)) or (evens and (n % 2 == 0)) or all
          data_point = OrganizerDataPoint.new
          data_point.organizer_id = current_user.id
          data_point.address = "#{n} #{params[:address]}"
          data_point.status = params[:status]
          data_point.save
        end
      end
    else
      data_point = OrganizerDataPoint.new
      data_point.organizer_id = current_user.id
      data_point.address = params[:address]
      data_point.status = params[:status]
      data_point.save
    end
    redirect_to :action => :map
  end

end
