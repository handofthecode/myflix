class PasswordResetsController < ApplicationController
  def show
    @user = User.find_by_token(params[:id])
    redirect_to expired_token_path unless @user
  end
  def expired
  end
  def create
    user = User.find_by_token(params[:token])
    user.password = params[:password]
    user.generate_token
    if user.save
      flash[:success] = "Password reset successfully! You may now sign in."
      redirect_to sign_in_path
    else
      flash[:error] = user.errors.full_messages.first
      redirect_to password_reset_path(user)
    end
  end
end