class QueueItemsController < ApplicationController
	before_filter :require_user
	def index
		@items = current_user.queue_items
	end
	def create
		v_id = params[:video_id]
		current_user.queue_items.create(video_id: v_id, position: new_item_position) unless video_in_queue?(v_id)
		redirect_to my_queue_path
	end
	def destroy
		item_id = params[:id]
		delete_record(item_id)
		redirect_to my_queue_path
	end

	private

	def delete_record(item_id)
		current_user.queue_items.delete(item_id) if item_in_queue?(item_id)
	rescue ActiveRecord::RecordNotFound
	  flash[:notice] = "Video does not exist"
	end

	def new_item_position
		current_user.queue_items.count + 1
	end

	def item_in_queue?(item_id)
		current_user.queue_items.find(item_id)
	end

	def video_in_queue?(v_id)
		current_user.queue_items.find_by video_id: v_id
	end
end