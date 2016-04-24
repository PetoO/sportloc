class LocationsController < ApplicationController
	include ActionView::Helpers::TextHelper
	before_action :find_location, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
	before_action :authenticate_user!, except: [:index, :show, :category, :all, :search, :categories]

	def index
		@locations = Location.all
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
		render 'all'
	end

	def show
		@comments = Comment.where(location_id: @location) 
		@tags = Location.find(params[:id]).tag_list
		@photos = Photo.where(location_id: @location)
	end

	def new
		@location = current_user.locations.build
	end
	
	def create
		@location = current_user.locations.build(location_params)

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
		redirect_to :back
	end

	def downvote
		@location.downvote_by current_user
		redirect_to :back
	end

	private

	def find_location
		@location = Location.find(params[:id])
	end

	def location_params
		params.require(:location).permit( :title, :description, :image, :lon, :lat, :tag_list, :page)
	end	
end
