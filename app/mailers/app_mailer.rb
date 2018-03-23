class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "Welcome to MyFlix!"
  end
  def send_forgot_password(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "reset password"
  end
  def send_invitation(invite)
    @invitation = invite
    mail to: @invitation.recipient_email, from: "info@myflix.com", subject: "#{@invitation.inviter} wants you to join myFlix!"
  end
end