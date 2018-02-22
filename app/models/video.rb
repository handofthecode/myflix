class Video < ActiveRecord::Base
	has_many :reviews, -> {order 'created_at DESC'}
	has_many :queue_items
	belongs_to :category

	validates_presence_of :title, :description

	def self.search_by_title(query)
		return [] if query.empty?
		where("title LIKE ?", "%#{query}%").order("created_at DESC")
	end

	def average_rating	
		(reviews.map(&:rating).inject(:+).to_f / reviews.size).round(1) if reviews.any?
	end
end