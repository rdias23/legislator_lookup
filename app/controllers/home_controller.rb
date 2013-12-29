class HomeController < ApplicationController
  before_filter :authenticate_user!, except: [:landing]

  def index
	@user = current_user
	@button_label = "Lookup!"
	@venue = Venue.last
  end

  def landing
    if !@auth.nil?
        redirect_to(home_index_path)
    end
  end

  def new_venue
	@user = User.find(params[:user_id])
	@address_string = String.new
	@address_string += params[:venue][:streetnumber]
	@address_string += " "
	@address_string += params[:venue][:streetname]
	@address_string += ", "
	@address_string += params[:venue][:city]
	@address_string += ", "
	@address_string += params[:venue][:state]
	@address_string += " "
	@address_string += params[:venue][:zipcode]
	@address_string += ", USA"
	
	params[:address] = @address_string

	@venue = Venue.create(venue_params)
	@venue.address = @address_string.to_s
	@venue.save	

    respond_to do |format|
        format.js {render :layout => false}
    end	
  end

  private
  def venue_params
    params.require(:venue).permit(:streetnumber, :streetname, :city, :state, :zipcode, :address)
  end
end



