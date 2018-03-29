class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean
    User.all.each do |user|
      user.admin = false
      user.save
    end
  end
end
