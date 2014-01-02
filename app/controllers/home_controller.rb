require 'json'
require 'rest-client'

class HomeController < ApplicationController
  before_filter :authenticate_user!, except: [:landing]

  def index
	@user = current_user
	@button_label = "Lookup!"

        @venues_to_destroy = Venue.all.where(:user_id => @user.id).where(:bookmark => false)

        @venues_to_destroy.each do |vn|
                vn.destroy
        end
  end

  def landing
    if !@auth.nil?
        redirect_to(home_index_path)
    end
  end

  def new_venue
	@user = User.find(params[:user_id])
	
	@venues_to_destroy = Venue.all.where(:user_id => @user.id).where(:bookmark => false)	

	@venues_to_destroy.each do |vn|
                vn.destroy
        end

	@space_string = " "
	@comma_space_string = ", "
	@comma_usa = ", USA"	
	params[:venue][:address] = params[:venue][:streetnumber] + @space_string + params[:venue][:streetname] + @comma_space_string + params[:venue][:city] + @comma_space_string + params[:venue][:state] + @space_string + params[:venue][:zipcode] + @comma_usa

	@venue = Venue.create(venue_params)
	@user.venues << @venue

	api_key = "f415f68ddbbb41d38868bb15cab0837e"

        venue_json = RestClient.get("http://congress.api.sunlightfoundation.com/legislators/locate?latitude=#{@venue.latitude}&longitude=#{@venue.longitude}&apikey=#{api_key}")
	venue_result_hash = JSON.load(venue_json)

	venue_result_hash["results"].each do |vrhr|
		if (vrhr["title"] == "Rep")
			params[:first_name] = vrhr["first_name"]
			params[:last_name] = vrhr["last_name"]
			params[:middle_name] = vrhr["middle_name"]
			params[:name_suffix] = vrhr["name_suffix"]
			params[:gender] = vrhr["gender"]
			params[:title] = vrhr["title"]
			params[:bioguide_id] = vrhr["bioguide_id"]
			params[:birthday] = vrhr["birthday"]
			params[:chamber] = vrhr["chamber"]
			params[:contact_form] = vrhr["contact_form"]
                        params[:district] = vrhr["district"]
                        params[:facebook_id] = vrhr["facebook_id"]
                        params[:fax] = vrhr["fax"]
                        params[:in_office] = vrhr["in_office"]
                        params[:nickname] = vrhr["nickname"]
                        params[:office] = vrhr["office"]
                        params[:party] = vrhr["party"]
                        params[:phone] = vrhr["phone"]
                        params[:state] = vrhr["state"]
                        params[:state_name] = vrhr["state_name"]
                        params[:term_end] = vrhr["term_end"]
                        params[:term_start] = vrhr["term_start"]
                        params[:twitter_id] = vrhr["twitter_id"]
                        params[:website] = vrhr["website"]
                        params[:youtube_id] = vrhr["youtube_id"]
                        params[:venue_id] = @venue.id

			@rep = Rep.create(rep_params)
			@venue.reps << @rep

		else
			if (vrhr["state_rank"] == "junior")
				params[:first_name] = vrhr["first_name"]
                        	params[:last_name] = vrhr["last_name"]
                        	params[:middle_name] = vrhr["middle_name"]
                        	params[:name_suffix] = vrhr["name_suffix"]
                        	params[:gender] = vrhr["gender"]
                        	params[:title] = vrhr["title"]
                        	params[:bioguide_id] = vrhr["bioguide_id"]
                        	params[:birthday] = vrhr["birthday"]
                        	params[:chamber] = vrhr["chamber"]
                        	params[:contact_form] = vrhr["contact_form"]
                        	params[:district] = vrhr["district"]
                        	params[:facebook_id] = vrhr["facebook_id"]
                        	params[:fax] = vrhr["fax"]
                        	params[:in_office] = vrhr["in_office"]
                        	params[:nickname] = vrhr["nickname"]
                        	params[:office] = vrhr["office"]
                        	params[:party] = vrhr["party"]
                        	params[:phone] = vrhr["phone"]
                        	params[:state] = vrhr["state"]
                        	params[:state_name] = vrhr["state_name"]
                        	params[:term_end] = vrhr["term_end"]
                        	params[:term_start] = vrhr["term_start"]
                        	params[:twitter_id] = vrhr["twitter_id"]
                        	params[:website] = vrhr["website"]
                        	params[:youtube_id] = vrhr["youtube_id"]
                        	params[:venue_id] = @venue.id
				params[:state_rank] = vrhr["state_rank"]
				params[:senate_class] = vrhr["senate_class"]

				@sen_jun = Sen.create(sen_params)
				@venue.sens << @sen_jun
			else
				params[:first_name] = vrhr["first_name"]
                                params[:last_name] = vrhr["last_name"]
                                params[:middle_name] = vrhr["middle_name"]
                                params[:name_suffix] = vrhr["name_suffix"]
                                params[:gender] = vrhr["gender"]
                                params[:title] = vrhr["title"]
                                params[:bioguide_id] = vrhr["bioguide_id"]
                                params[:birthday] = vrhr["birthday"]
                                params[:chamber] = vrhr["chamber"]
                                params[:contact_form] = vrhr["contact_form"]
                                params[:district] = vrhr["district"]
                                params[:facebook_id] = vrhr["facebook_id"]
                                params[:fax] = vrhr["fax"]
                                params[:in_office] = vrhr["in_office"]
                                params[:nickname] = vrhr["nickname"]
                                params[:office] = vrhr["office"]
                                params[:party] = vrhr["party"]
                                params[:phone] = vrhr["phone"]
                                params[:state] = vrhr["state"]
                                params[:state_name] = vrhr["state_name"]
                                params[:term_end] = vrhr["term_end"]
                                params[:term_start] = vrhr["term_start"]
                                params[:twitter_id] = vrhr["twitter_id"]
                                params[:website] = vrhr["website"]
                                params[:youtube_id] = vrhr["youtube_id"]
                                params[:venue_id] = @venue.id
                                params[:state_rank] = vrhr["state_rank"]
                                params[:senate_cls] = vrhr["senate_class"]
    
                                @sen_sen = Sen.create(sen_params)
				@venue.sens << @sen_sen
			end
		end
	end

	@rep_image_ref = '/congress/' + @venue.reps[0].bioguide_id.to_s + '.jpg'
	@sen_senior_image_ref = '/congress/' + @venue.sens.where(:state_rank => "senior")[0].bioguide_id.to_s + '.jpg'
	@sen_junior_image_ref = '/congress/' + @venue.sens.where(:state_rank => "junior")[0].bioguide_id.to_s + '.jpg'


    respond_to do |format|
        format.js {render :layout => false}
    end	
  end

  def bookmark_venue
	@venue = Venue.find(params[:id])
	@venue.bookmark = true
	@venue.save
	flash[:notice] = "Address information has been bookmarked!"

    respond_to do |format|
	format.js {render :layout => false}
    end		

  end


  private
  def venue_params
    params.require(:venue).permit(:user_id, :streetnumber, :streetname, :city, :state, :zipcode, :address)
  end

  def rep_params
    params.permit(:first_name, :last_name, :middle_name, :name_suffix, :gender, :title, :bioguide_id, :birthday, :chamber, :contact_form, :district, :facebook_id, :fax, :in_office, :nickname, :office, :party, :phone, :state, :state_name, :term_end, :term_start, :twitter_id, :website, :youtube_id, :venue_id)
  end

  def sen_params
    params.permit(:first_name, :last_name, :middle_name, :name_suffix, :gender, :title, :bioguide_id, :birthday, :chamber, :contact_form, :district, :facebook_id, :fax, :in_office, :nickname, :office, :party, :phone, :state, :state_name, :term_end, :term_start, :twitter_id, :website, :youtube_id, :venue_id, :state_rank, :senate_class)
  end
end



