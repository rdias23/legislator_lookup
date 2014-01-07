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

    if(params.has_key?(:bookmark))
	@venue = Venue.find(params[:id])
    else	
	@space_string = " "
	@comma_space_string = ", "
	@comma_usa = ", USA"	
	params[:venue][:address] = params[:venue][:streetnumber] + @space_string + params[:venue][:streetname] + @comma_space_string + params[:venue][:city] + @comma_space_string + params[:venue][:state] + @space_string + params[:venue][:zipcode] + @comma_usa

	@venue = Venue.create(venue_params)
	@user.venues << @venue
     end

	api_key = "f415f68ddbbb41d38868bb15cab0837e"

        leg_json = RestClient.get("http://congress.api.sunlightfoundation.com/legislators/locate?latitude=#{@venue.latitude}&longitude=#{@venue.longitude}&apikey=#{api_key}")
	leg_result_hash = JSON.load(leg_json)

	leg_result_hash["results"].each do |vrhr|
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

			rep_json = RestClient.get("http://congress.api.sunlightfoundation.com/committees?member_ids=#{@rep.bioguide_id}&apikey=#{api_key}")
			rep_result_hash = JSON.load(rep_json)
			
				rep_result_hash["results"].each do |rrhr|
					if(rrhr["subcommittee"] == false)
						params[:chamber] = rrhr["chamber"]
						params[:committee_id] = rrhr["committee_id"]
						params[:name] = rrhr["name"]
						params[:subcommittee] = rrhr["subcommittee"]
						@com = Com.create(com_params)
                        			@rep.coms << @com
					else
						params[:chamber] = rrhr["chamber"]
                                                params[:committee_id] = rrhr["committee_id"]
						params[:parent_committee_id] = rrhr["parent_committee_id"]
                                                params[:name] = rrhr["name"]
                                                params[:subcommittee] = rrhr["subcommittee"]
						@com = Com.create(com_params)
                                                @rep.coms << @com
					end
				end
		elsif (vrhr["title"] == "Del")
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

                        @del = Del.create(del_params)
                        @venue.dels << @del

                        del_json = RestClient.get("http://congress.api.sunlightfoundation.com/committees?member_ids=#{@del.bioguide_id}&apikey=#{api_key}")
                        del_result_hash = JSON.load(del_json)

                                del_result_hash["results"].each do |drhr|
                                        if(drhr["subcommittee"] == false)
                                                params[:chamber] = drhr["chamber"]
                                                params[:committee_id] = drhr["committee_id"]
                                                params[:name] = drhr["name"]
                                                params[:subcommittee] = drhr["subcommittee"]
                                                @com = Com.create(com_params)
                                                @del.coms << @com
                                        else
                                                params[:chamber] = drhr["chamber"]
                                                params[:committee_id] = drhr["committee_id"]
                                                params[:parent_committee_id] = drhr["parent_committee_id"]
                                                params[:name] = drhr["name"]
                                                params[:subcommittee] = drhr["subcommittee"]
                                                @com = Com.create(com_params)
                                                @del.coms << @com
                                        end
                                end
		elsif (vrhr["title"] == "Sen")
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

				sen_jun_json = RestClient.get("http://congress.api.sunlightfoundation.com/committees?member_ids=#{@sen_jun.bioguide_id}&apikey=#{api_key}")
                        	sen_jun_result_hash = JSON.load(sen_jun_json)

                                sen_jun_result_hash["results"].each do |sjrhr|
                                        if(sjrhr["subcommittee"] == false)
                                                params[:chamber] = sjrhr["chamber"]
                                                params[:committee_id] = sjrhr["committee_id"]
                                                params[:name] = sjrhr["name"]
                                                params[:subcommittee] = sjrhr["subcommittee"]
                                                @com = Com.create(com_params)
                                                @sen_jun.coms << @com
                                        else
                                                params[:chamber] = sjrhr["chamber"]
                                                params[:committee_id] = sjrhr["committee_id"]
                                                params[:parent_committee_id] = sjrhr["parent_committee_id"]
                                                params[:name] = sjrhr["name"]
                                                params[:subcommittee] = sjrhr["subcommittee"]
                                                @com = Com.create(com_params)
                                                @sen_jun.coms << @com
                                        end
                                end
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

                                sen_sen_json = RestClient.get("http://congress.api.sunlightfoundation.com/committees?member_ids=#{@sen_sen.bioguide_id}&apikey=#{api_key}")
                                sen_sen_result_hash = JSON.load(sen_sen_json)
                                
                                sen_sen_result_hash["results"].each do |ssrhr|
                                        if(ssrhr["subcommittee"] == false)
                                                params[:chamber] = ssrhr["chamber"]
                                                params[:committee_id] = ssrhr["committee_id"]
                                                params[:name] = ssrhr["name"]
                                                params[:subcommittee] = ssrhr["subcommittee"]
                                                @com = Com.create(com_params)
                                                @sen_sen.coms << @com
                                        else
                                                params[:chamber] = ssrhr["chamber"]
                                                params[:committee_id] = ssrhr["committee_id"]
                                                params[:parent_committee_id] = ssrhr["parent_committee_id"]
                                                params[:name] = ssrhr["name"]
                                                params[:subcommittee] = ssrhr["subcommittee"]
                                                @com = Com.create(com_params)
                                                @sen_sen.coms << @com
                                        end
                                end
			end
		
		else
		end
	end

	if @venue.reps[0] != nil
		@rep_image_ref = '/congress/' + @venue.reps[0].bioguide_id.to_s + '.jpg'
	else
	end

	if @venue.sens.where(:state_rank => "senior")[0] != nil
		@sen_senior_image_ref = '/congress/' + @venue.sens.where(:state_rank => "senior")[0].bioguide_id.to_s + '.jpg'
	else
	end

	if @venue.sens.where(:state_rank => "junior")[0] != nil
		@sen_junior_image_ref = '/congress/' + @venue.sens.where(:state_rank => "junior")[0].bioguide_id.to_s + '.jpg'
	else
	end

	if @venue.dels[0] != nil
                @del_image_ref = '/congress/' + @venue.dels[0].bioguide_id.to_s + '.jpg'
        else
        end


	(@rep_coms = @rep.coms.where(:subcommittee => false)) if (@rep != nil)
	(@rep_subcoms = @rep.coms.where(:subcommittee => true)) if (@rep != nil)

        (@sen_jun_coms = @sen_jun.coms.where(:subcommittee => false)) if (@sen_jun != nil)
        (@sen_jun_subcoms = @sen_jun.coms.where(:subcommittee => true)) if (@sen_jun != nil)

        (@sen_sen_coms = @sen_sen.coms.where(:subcommittee => false)) if (@sen_sen != nil)
        (@sen_sen_subcoms = @sen_sen.coms.where(:subcommittee => true)) if (@sen_sen != nil)

        (@del_coms = @del.coms.where(:subcommittee => false)) if (@del != nil)
        (@del_subcoms = @del.coms.where(:subcommittee => true)) if (@del != nil)

	@zooms = Zoom.all.where(:user_id => @user.id)
	@zooms.each { |zm| zm.destroy }

	@zoom = Zoom.create(zoom_params)
	@user.zooms << @zoom

    respond_to do |format|
        format.js {render :layout => false}
    end	
  end

  def update_venue
	@user = User.find(params[:user_id])
	@venue = Venue.find(params[:id])

	@space_string = " "

	params[:venue][:residentname] = params[:venue][:resident_first] + @space_string + params[:venue][:resident_last]
	
	@venue.update_attributes(params.require(:venue).permit(:resident_first, :resident_last, :residentname, :notes))
	flash[:notice] = "Address Information Updated! (remember to bookmark)"

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

  def update_zoom
	@zoom = Zoom.find(params[:id])
	@zoom.level = params[:zoom][:level]
	@zoom.save

	@user = User.find(params[:user_id])
	@venue  = @user.venues.order("id ASC").last

    respond_to do |format|
        format.js {render :layout => false}
    end 
  end

  def show_bookmarks

   if (params.has_key?(:id))
	@user = current_user
        @venues_bookmarked = @user.venues.where(:bookmark => true)

    respond_to do |format|
        format.js {render :layout => false}
    end      
   else
      redirect_to(home_index_path)
   end
  end

  def delete_bookmark
	@bookmark_to_destroy = Venue.find(params[:id])
	@user = User.find(@bookmark_to_destroy.user.id)

	@bookmark_to_destroy.destroy

	@venues_bookmarked = @user.venues.where(:bookmark => true)
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

  def del_params
    params.permit(:first_name, :last_name, :middle_name, :name_suffix, :gender, :title, :bioguide_id, :birthday, :chamber, :contact_form, :district, :facebook_id, :fax, :in_office, :nickname, :office, :party, :phone, :state, :state_name, :term_end, :term_start, :twitter_id, :website, :youtube_id, :venue_id, :state_rank, :senate_class)
  end

  def com_params
    params.permit(:chamber, :committee_id, :name, :parent_committee_id, :subcommittee, :rep_id, :sen_id, :del_id) 
  end
	
  def zoom_params
   params.permit(:level, :user_id)
  end
end



