class AddReviews < ActiveRecord::Migration
  def change
  	create_table :reviews do |t|
  		t.string :content
  		t.integer :rating
  		t.timestamps
  	end
  	add_reference :reviews, :video, foreign_key: true
  	add_reference :reviews, :user, foreign_key: true
  end

end
