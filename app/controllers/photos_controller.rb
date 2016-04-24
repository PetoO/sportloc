class PhotosController < ApplicationController
	def create
		@location = Location.find(params[:location_id])
		@photo = Photo.create(params[:photo].permit(:title, :photo))
		@photo.user_id = current_user.id
		@photo.location_id = @location.id

		if @photo.save 
			redirect_to location_path(@location)
		else
			
			redirect_to location_path(@location)
		end
	end
end
