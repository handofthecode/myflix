module ApplicationHelper
	def average_rating(review)
		(review.map(&:rating).inject(:+).to_f / review.size).round 1
	end
end
