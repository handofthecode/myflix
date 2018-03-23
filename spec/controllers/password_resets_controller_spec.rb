require 'spec_helper'

describe PasswordResetsController do
  describe 'GET show' do
    it 'renders show if token is valid' do
      user = Fabricate(:user)
      get :show, id: user.token
      expect(response).to render_template :show
    end
    it 'redirects to expired token path if token is invalid' do
      get :show, id: 'sdfsd'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe 'POST create' do
    context 'with valid token' do

      it 'updates password' do
        user = Fabricate(:user)
        post :create, token: user.token, password: 'newpass'
        user.reload
        expect(user.authenticate('newpass')).to be user
      end
      it 'redirects to sign_in page' do
        user = Fabricate(:user)
        post :create, token: user.token, password: 'newpass'
        expect(response).to redirect_to sign_in_path
      end
      it 'sets the flash success' do
        user = Fabricate(:user)
        post :create, token: user.token, password: 'newpass'
        expect(flash[:success]).to eq("Password reset successfully! You may now sign in.")
      end
      it 'regenerates user token' do
        user = Fabricate(:user)
        first_token = user.token
        post :create, token: user.token, password: 'newpass'
        expect(first_token).to eq(user.token)
      end
    end
  end
end