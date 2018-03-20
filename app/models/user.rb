class User < ActiveRecord::Base
	has_many :reviews, -> { order("created_at DESC")}
	has_many :queue_items, -> { order("position ASC") }
	has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
	has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id


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

	def follows?(leader)
		!!following_relationships.find_by(leader: leader)
	end

	def can_follow?(other_user)
		other_user != self && !self.follows?(other_user)
	end
end