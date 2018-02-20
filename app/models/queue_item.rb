class QueueItem < ActiveRecord::Base
	has_one :video
	belongs_to :user
end