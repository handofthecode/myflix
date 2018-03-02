class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :require_user, :star_ratings

  def current_user
		@current_user || User.find(session[:user_id]) if session[:user_id]
	end

	def logged_in?
		!!current_user
	end

	def require_user
		unauthenticated_user unless logged_in?
	end

	def unauthenticated_user
		flash[:error] = 'You must log in to do that.'
		redirect_to sign_in_path
	end
	
	def star_ratings
		(1..5).map{|n| ["#{n} #{"star".pluralize(n)}", n.to_s]}
	end
end
