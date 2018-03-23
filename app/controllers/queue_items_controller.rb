class QueueItemsController < ApplicationController
	before_filter :require_user
	helper_method :users_own_review, :users_own_rating
	def index
		@items = current_user.queue_items
	end
	def create
		video = Video.find(params[:video_id])
		current_user.queue_items.create(video: video, position: new_item_position) unless current_user.in_queue?(video)
		redirect_to my_queue_path
	end
	def destroy
		item_id = params[:id]
		delete_record(item_id)
		current_user.normalize_queue_item_position
		redirect_to my_queue_path
	end
	def update
		update_each
		current_user.normalize_queue_item_position
		redirect_to my_queue_path
	end

	private

	def update_each
		begin
			ActiveRecord::Base.transaction do
				params[:queue_items].each do |update|
					item = current_user.queue_items.find(update[:id])
					# set_rating item, update if rating_update?(update)
					item.update!(position: update[:position], own_rating: update[:rating])
				end
			end
		rescue ActiveRecord::RecordNotFound
	  	flash[:error] = "There was something wrong with your queue order change"
	  rescue ActiveRecord::RecordInvalid
	  	flash[:error] = "Invalid position value"
	  end
	end

	def delete_record(item_id)
		current_user.queue_items.delete(item_id) if current_user.in_queue?(item_id)
	rescue ActiveRecord::RecordNotFound
	  flash[:error] = "Video does not exist"
	end

	def new_item_position
		current_user.queue_items.count + 1
	end
end