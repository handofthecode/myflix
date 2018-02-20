class AddCategories < ActiveRecord::Migration
  def change
  	create_table :categories do |c|
  		c.string :name
  	end
  	add_reference :videos, :category, foreign_key: true
  end
end
