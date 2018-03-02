class QueueItem < ActiveRecord::Base
	belongs_to :video
	belongs_to :user

	delegate :category, to: :video
	delegate :title, to: :video, prefix: :video
	delegate :reviews, to: :video

	validates_numericality_of :position, {only_integer: true}

	def video_category
		category.name
	end

	def rating
		video.average_rating
	end

	def own_rating
		review.rating if review
	end

	def own_rating=(new_rating)
		return nil unless new_rating
		if review
			review.update_column(:rating, new_rating)
		else
			review = Review.new(user: user, video: video, rating: new_rating)
			review.save(validate: false)
		end
	end

	private

	def review
		@review ||= Review.find_by(user: user, video: video)
	end
end