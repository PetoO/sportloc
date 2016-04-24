class CommentsController < ApplicationController
	before_action :authenticate_user!
	
	def create
		@location = Location.find(params[:location_id])
		@comment = Comment.create(params[:comment].permit(:content))
		@comment.user_id = current_user.id
		@comment.location_id = @location.id

		if @comment.save 
			redirect_to location_path(@location)
		else
			render 'new'
		end
	end
end
