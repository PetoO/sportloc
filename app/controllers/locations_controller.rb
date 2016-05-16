class LocationsController < ApplicationController
	include ActionView::Helpers::TextHelper
	before_action :find_location, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
	before_action :authenticate_user!, except: [:index, :show, :category, :all, :search, :categories]

	def index
		@locations = Location.all.order("created_at DESC").paginate(:page => params[:page],:per_page => 24)
		 @latest_locations = Location.order("created_at DESC").paginate(:page => params[:page],:per_page => 4)
		 @most_locations = Location.order("created_at DESC").paginate(:page => params[:page],:per_page => 4)
	end

	def categories
		 @locations = Location.order("created_at DESC").paginate(:page => params[:page],:per_page => 24)
	end

	def category
		@locations = Location.all.order("created_at DESC").tagged_with(params[:tag]).paginate(:page => params[:page],:per_page => 24)
		@header=params[:tag].pluralize.capitalize
		render 'all'
	end

	def all
		@locations = Location.all.order("created_at DESC").paginate(:page => params[:page],:per_page => 24)
		@header="All Locations"
	end

	def search
		@locations = Location.all.order("created_at DESC").where("title LIKE ? ", "%#{params[:q]}%").paginate(:page => params[:page],:per_page => 24)
		@header="Search results"
		render 'all'
	end	

	def my
		@locations = Location.all.order("created_at DESC").where(user_id: current_user.id).order("created_at DESC").paginate(:page => params[:page],:per_page => 24)
		# if @locations.empty?
		# 	flash[:notice] = "You have no locations created yet!"
		# end
		render 'all'
	end

	def show
		#@location = Location.find(params[:id])
	# 	@photos = Photo.where(location_id: @location).order("created_at desc").to_a
		@comments = Comment.where(location_id: @location) 
		@tags = Location.find(params[:id]).tag_list
		@photos = Photo.where(location_id: @location)
	end

	def new
		@location = current_user.locations.build
		# @photo = Photo.new(:title => "My photo \##{1 + (Photo.maximum(:id) || 0)}")
	end
	
	def create
		@location = current_user.locations.build(location_params)
		#@location.tag_list.add()
		#@paraams = params[:photo]
		#@photo = Photo.new(params[:photo])
		#@photo.location_id = @location.id
		#@photo.user_id = current_user.id
		#@photo.save


		if @location.save
			redirect_to @location
		else
			render 'new'
		end
	end

	def edit
		@tag_list = @location.tag_list.join(", ")
	end

	def update
		if @location.update(location_params)
			redirect_to @location
		else
			render 'edit'
		end
	end

	def destroy
		@location.destroy
		redirect_to root_path
	end

	def upvote
		@location.upvote_by current_user
	end

	def downvote
		@location.downvote_by current_user
	end

	private

	def find_location
		@location = Location.find(params[:id])
	end

	def location_params
		params.require(:location).permit( :title, :description, :image, :lon, :lat, :tag_list, :page)
	end	
end
