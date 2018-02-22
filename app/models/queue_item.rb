class QueueItem < ActiveRecord::Base
	belongs_to :video
	belongs_to :user

	delegate :category, to: :video
	delegate :title, to: :video, prefix: :video

	def video_category
		category.name
	end

	def rating
		video.average_rating
	end
end