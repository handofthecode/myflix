class VideosController < ApplicationController
	before_filter :require_user
	def index
		@categories = Category.all
	end
	def show
		@video = VideoDecorator.decorate Video.find(params[:id])
		@reviews = @video.reviews
	end
	def search
		@results = Video.search_by_title params[:search]
	end
	def advanced_search
		options = {
			reviews: params[:reviews],
			rating_from: params[:rating_from],
			rating_to: params[:rating_to]
		}
		@videos = if params[:query]
			Video.search(params[:query], options).records.to_a
		else
			[]
		end
	end
end