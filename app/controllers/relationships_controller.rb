class RelationshipsController < ApplicationController
  before_filter :require_user
  def create
    relationship = Relationship.new(follower: current_user, leader_id: params[:id])
    if relationship.save
      flash[:success] = "You are now following #{User.find(params[:id]).full_name}"
    else
      flash[:error] = relationship.errors.full_messages.first
    end
    redirect_to user_path params[:id]
  end
  def index
    @relationships = current_user.following_relationships
  end
  def destroy
    relationship = current_user.following_relationships.find_by(id: params[:id])
    relationship.destroy if relationship
    redirect_to people_path
  end
end