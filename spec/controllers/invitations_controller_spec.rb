require 'spec_helper'

describe InvitationsController do
  describe 'GET new' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end
    it 'sets @invitation' do
      user = authenticate
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end
  end

  describe 'POST create' do
    it_behaves_like 'requires sign in' do
      let(:action) { post :create }
    end
    context 'with valid input' do
      before do
        user = authenticate
        post :create, invitation: {recipient_name: 'bob', recipient_email: 'bob@hotmail.com', message: 'join us!'}
      end
      it 'redirects to the invitation page' do
        expect(response).to redirect_to new_invitation_path
      end
      it 'sets the flash[:success]' do
        expect(flash[:success]).to be_present
      end
      it 'creates an invitation' do
        expect(Invitation.count).to eq(1)
      end
      it 'sends an email to the recipient' do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['bob@hotmail.com'])
      end
    end
    context 'with invalid input' do
      before do
        ActionMailer::Base.deliveries.clear
        user = authenticate
        post :create, invitation: {recipient_email: 'bob@hotmail.com', message: 'join us!'}
      end
      it 'renders the :new template' do
        expect(response).to render_template :new
      end
      it 'does not create an invitation' do
        expect(Invitation.count).to eq(0)
      end
      it 'sets the flash error message' do
        expect(flash[:error]).to be_present
      end
      it 'does not send an email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it 'has an ivar set' do
        expect(assigns(:invitation)).to be_instance_of Invitation
      end
    end
  end
end