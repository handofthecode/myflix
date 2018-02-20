class Video < ActiveRecord::Base
	has_many :reviews, -> {order 'created_at DESC'}
	belongs_to :category

	validates_presence_of :title, :description

	def self.search_by_title(query)
		return [] if query.empty?
		where("title LIKE ?", "%#{query}%").order("created_at DESC")
	end
end