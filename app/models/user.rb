class User < ActiveRecord::Base
	include Tokenable
	has_many :reviews, -> { order("created_at DESC")}
	has_many :queue_items, -> { order("position ASC") }
	has_many :invitations
	has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
	has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id

	validates_presence_of :full_name, :password, :email
	validates_uniqueness_of :email
	has_secure_password validations: false

	def admin?
		!!admin
	end
	def followers
		leading_relationships.map do |relationship|
			relationship.follower
		end
	end
	def following
		following_relationships.map do |relationship|
			relationship.leader
		end
	end
	def follow(other_user)
		Relationship.create(follower: self, leader: other_user)
	end
	def normalize_queue_item_position
		queue_items.each_with_index.map do |item, idx|
			item.update(position: idx + 1)
		end
	end

	def to_param
		token
	end

	def in_queue?(item)
		if queue_items.any?
			!!(item.class == Video ? queue_items.find_by(video: item) : queue_items.find(item))
		else
			false
		end
	end

	def follows?(leader)
		!!following_relationships.find_by(leader: leader)
	end

	def can_follow?(other_user)
		other_user != self && !self.follows?(other_user)
	end
end