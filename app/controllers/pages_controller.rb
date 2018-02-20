class PagesController < ApplicationController
	def front
		if logged_in?
			redirect_to videos_path
		end
	end
end