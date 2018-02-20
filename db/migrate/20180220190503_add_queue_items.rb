class AddQueueItems < ActiveRecord::Migration
  def change
  	create_table :queue_items do |t|
  		t.integer :position
  		t.timestamps
  	end
  	add_reference :queue_items, :video, foreign_key: true
  	add_reference :queue_items, :user, foreign_key: true
  end
end
