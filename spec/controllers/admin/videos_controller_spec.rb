require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it_behaves_like 'requires sign in' do
      let(:action) {get :new}
    end
    it_behaves_like 'requires admin' do
      let(:action) {get :new}
    end
    context 'is admin' do
      let(:admin) { Fabricate(:admin) }
      before { authenticate admin; get :new }
      it "sets @video to a new video" do
        expect(assigns(:video)).to be_instance_of(Video)
      end
    end
  end

  describe 'POST create' do
    it_behaves_like 'requires sign in' do
      let(:action) {post :create}
    end
    it_behaves_like 'requires admin' do
      let(:action) {post create}
    end
    context "with valid input" do
      let(:category) { Fabricate(:category) }
      before do
        Video.all.destroy_all
        authenticate Fabricate(:admin)
        post :create, video: {title: 'Jurassic Park', category_id: category.id, description: 'Great movie!'}
      end
      it "creates a video" do
        expect(Video.all.count).to eq(1)
      end
      it "redirects to the add new video page" do
        expect(response).to redirect_to new_admin_video_path
      end
      it "sets the flash success message" do
        expect(flash[:success]).to be_present
      end
    end
    context "with invalid input" do
      before do 
        Video.all.destroy_all
        authenticate Fabricate(:admin)
        post :create, video: {title: 'Jurassic Park'}
      end
      it "does not create a video" do
        expect(Video.all.count).to eq(0)
      end
      it "renders a new template" do
        expect(response).to render_template :new
      end
      it "sets the @video variable" do
        expect(assigns(:video)).to be_instance_of(Video)
      end
      it "sets a flash error message" do
        expect(flash[:error]).to be_present
      end
    end
  end

end