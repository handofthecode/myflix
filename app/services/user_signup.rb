class UserSignup
  attr_reader :error_message, :success_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
		if @user.save && charge_card(stripe_token)
			handle_invitation_relationships invitation_token
			AppMailer.delay.send_welcome_email(@user)
      @success_message = "Welcome #{@user.full_name}! You can now sign in."
    else
      @error_message ||= "Please fix issues with user info."
			@user.destroy
    end
    self
  end

  def successful?
    @success_message.present?
  end

  private

  def charge_card(stripe_token)
		charge = StripeWrapper::Charge.create(
			:email => @user.email,
			:source  => stripe_token,
			:description => "Sign up charge for #{@user.email}"
    )
    if charge.successful?
      true
    else
      @error_message = charge.error_message
      false
    end
  end

  def handle_invitation_relationships(invitation_token)
		if !invitation_token.blank?
      invitation = Invitation.find_by_token(invitation_token)
      inviter = invitation.inviter
      @user.follow inviter
      inviter.follow @user
      invitation.destroy
		end
  end
end