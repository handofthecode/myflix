require 'spec_helper'

describe RelationshipsController do
  context 'simple relationship' do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    describe 'GET index' do
      it "sets @relationships to the current_user's following relationships" do
        authenticate alice
        relationship =  Fabricate(:relationship, follower: alice, leader: bob)
        get :index
        expect(assigns(:relationships)).to eq([relationship])
      end

      it_behaves_like "requires sign in" do
        let(:action) {get :index}
      end
    end

    describe 'DELETE destroy' do
      it_behaves_like "requires sign in" do
        let(:action) {delete :destroy, id: 5}
      end
      it 'deletes the relationship if the current_user is the follower' do
        relationship =  Fabricate(:relationship, follower: alice, leader: bob)
        authenticate alice
        delete :destroy, id: relationship.id
        expect(Relationship.count).to eq(0)
      end
      it 'redirects to the people page' do
        relationship =  Fabricate(:relationship, follower: alice, leader: bob)
        authenticate alice
        delete :destroy, id: relationship.id
        expect(response).to redirect_to people_path
      end
      it 'does not delete the relationship if the current_user is not the follower' do
        authenticate bob
        relationship = Fabricate(:relationship, follower: alice, leader: bob)
        delete :destroy, id: relationship.id
        expect(Relationship.count).to eq(1)
      end
    end

    describe 'POST create' do
      it_behaves_like "requires sign in" do
        let(:action) {post :create, id: 5}
      end
      it 'creates a new relationship' do
        authenticate alice
        post :create, id: bob.id
        expect(Relationship.count).to eq(1)
      end
      it "redirects to leader page" do
        authenticate alice
        post :create, id: bob.id
        expect(response).to redirect_to user_path(bob)
      end
      it "does not create a relationship if the follower already follows the leader" do
        authenticate alice
        post :create, id: bob.id
        post :create, id: bob.id
        expect(Relationship.count).to eq(1)
      end
      it "cannot create a relationship between the same user and herself" do
        authenticate alice
        post :create, id: alice.id
        expect(Relationship.count).to eq(0)
      end
    end
  end
end