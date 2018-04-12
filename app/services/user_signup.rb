class UserSignup
  attr_reader :error_message, :success_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)

    if @user.save && subscribe_customer(stripe_token)
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

  def subscribe_customer(stripe_token)
		@customer = StripeWrapper::Customer.create(
			:email => @user.email,
			:source  => stripe_token,
			:description => "Registered #{@user.email}"
    )
    if @customer.successful?
      @user.update_column(:customer_id, customer_id)
      subscribe
      true
    else
      @error_message = @customer.error_message
      false
    end
  end

  def subscribe
    Stripe::Subscription.create(
      customer: customer_id,
      items: [
        {
          plan: "plan_CenYtY4sih2FUJ"
        }
      ]
    )
  end

  def customer_id
    @customer_id ||= JSON.parse(@customer.response.to_s)["id"]
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