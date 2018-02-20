class ReviewsController < ApplicationController
	before_filter :require_user
	def create
		@video = Video.find(params[:video_id])
		review = Review.new(review_params.merge!({video: @video, user: current_user}))

		if review.save
			redirect_to @video
		else
			@reviews = @video.reviews
			render 'videos/show'
		end
	end

	private

	def review_params
		params.require(:review).permit(:content, :rating)
	end
end