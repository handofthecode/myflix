class AddVideos < ActiveRecord::Migration
  def change
  	create_table :videos do |v|
  		v.string :title
  		v.string :description
  		v.string :small_cover_url
  		v.string :large_cover_url
  		v.timestamps
  	end
  end
end
