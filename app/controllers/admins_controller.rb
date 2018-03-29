class AdminsController < ApplicationController
  before_filter :require_user, :ensure_admin

  def ensure_admin
    unless !!current_user && current_user.admin? 
      flash[:error] = "You are not authorized to do that"
      redirect_to root_path
    end
  end
end