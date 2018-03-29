class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "#{@video.title} added successfully!"
      redirect_to new_admin_video_path
    else
      flash[:error] = "Invalid parameters. Video not added."
      render :new
    end
  end

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :large_cover, :small_cover)
  end
end