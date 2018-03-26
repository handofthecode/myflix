class InvitationsController < ApplicationController
  before_filter :require_user
  def new
    @invitation = Invitation.new
  end
  def create
    @invitation = Invitation.create(invitation_params.merge!(inviter_id: current_user.id))
    if @invitation.save
      AppMailer.send_invitation(@invitation).deliver
      flash[:success] = 'Invitation sent!'
      redirect_to new_invitation_url
    else
      flash[:error] = @invitation.errors.full_messages.first
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end
end