class ForgotPasswordsController < ApplicationController
  def new
  end
  def create
    user = User.find_by_email(params[:email])
    if user
      AppMailer.delay.send_forgot_password(user)
      flash[:success] = "Reset email has been sent to #{user.email}"
      redirect_to forgot_password_confirmation_url
    elsif params[:email].blank?
      flash[:error] = 'Email field must not be blank'
      redirect_to forgot_password_path
    else
      flash[:error] = 'Email not associated with account'
      redirect_to forgot_password_path
    end
  end
  def confirm

  end
end