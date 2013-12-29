class HomeController < ApplicationController
  before_filter :authenticate_user!, except: [:landing]

  def index
	@user = current_user
	@button_label = "Lookup!"
	@venue = Venue.new
  end

  def landing
    if !@auth.nil?
        redirect_to(home_index_path)
    end
  end

  def new_venue
	@user = User.find(params[:user_id])

	@space_string = " "
	@comma_space_string = ", "
	@comma_usa = ", USA"	
	params[:venue][:address] = params[:venue][:streetnumber] += @space_string += params[:venue][:streetname] += @comma_space_string += params[:venue][:city] += @space_string += params[:venue][:state]  += @space_string += params[:venue][:zipcode] += @comma_usa

	@venue = Venue.create(venue_params)

    respond_to do |format|
        format.js {render :layout => false}
    end	
  end

  private
  def venue_params
    params.require(:venue).permit(:streetnumber, :streetname, :city, :state, :zipcode, :address)
  end
end



