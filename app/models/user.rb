class User < ActiveRecord::Base
	has_many :reviews
	has_many :queue_items, -> { order("position ASC") }
	validates_presence_of :full_name, :password, :email
	validates_uniqueness_of :email

	has_secure_password validations: false

	def normalize_queue_item_position
		queue_items.each_with_index.map do |item, idx|
			item.update(position: idx + 1)
		end
	end

	def in_queue?(item)
		!!(item.class == Video ? queue_items.find_by(video: item) : queue_items.find(item))
	end
end