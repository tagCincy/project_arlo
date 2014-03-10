require 'spec_helper'

describe Api::Service::V1::GroupsController do

  let(:valid_group) { create :group }
  let(:valid_attributes) { attributes_for :group }
  let(:invalid_group_attributes) { attributes_for :invalid_group_params }

  describe 'GET index' do

    before :each do
      @groups = Array(3..6).sample.times.map do
        create :group
      end
    end

    it 'should return a valid response' do
      get :index, {format: 'json'}
      expect(response.status).to eq 200
    end

    it 'should return an array of groups' do
      get :index, {format: 'json'}
      expect(assigns :groups).to eq @groups
    end
  end

  describe 'GET show' do

    it 'should have a valid response' do
      get :show, {format: 'json', id: valid_group.to_param}
      expect(response.status).to eq 200
    end

    it 'assigns the requested account as @account' do
      get :show, {format: 'json', id: valid_group.to_param}
      expect(assigns :group).to eq valid_group
    end

    it 'should return a failure response if the group does not exist' do
      get :show, {format: 'json', id: 99}
      expect(response.status).to eq 400
    end
  end

  describe 'POST create' do

    describe 'with valid params' do

      before :each do
        @account = create :account
      end

      it 'should return a valid response' do
        post :create, {format: 'json', group: valid_attributes.merge(admin_id: @account.id)}
        expect(response.status).to eq 201
      end

      it 'creates a new Group' do
        expect {
          post :create, {format: 'json', group: valid_attributes.merge(admin_id: @account.id)}
        }.to change(Group, :count).by(1)
      end

      it 'assigns a newly created group as @group' do
        post :create, {format: 'json', group: valid_attributes.merge(admin_id: @account.id)}
        expect(assigns :group).to be_a(Group)
        expect(assigns :group).to be_persisted
      end

      it 'should render the show template' do
        post :create, {format: 'json', group: valid_attributes.merge(admin_id: @account.id)}
        expect(response).to render_template :show
      end
    end

    describe 'with invalid params' do

      it 'should return a failure response' do
        post :create, {format: 'json', group: invalid_group_attributes}
        expect(response.status).to eq 422
      end

      it 'should not create a new group' do
        expect {
          post :create, {format: 'json', group: invalid_group_attributes}
        }.not_to change(Group, :count)
      end

      it 'should return errors' do
        post :create, {format: 'json', group: invalid_group_attributes}
        expect(assigns(:group).errors).not_to be_nil
      end
    end
  end

  describe 'PATCH update' do

    before :each do
      @group = create :group
    end

    describe 'with valid params' do

      before :each do
        @desc = Faker::Lorem.sentence
      end

      it 'should have a valid response' do
        patch :update, {format: 'json', id: @group.to_param, group: {description: @desc}}
        expect(response.status).to eq 200
      end

      it 'should update the group' do
        patch :update, {format: 'json', id: @group.to_param, group: {description: @desc}}
        expect(assigns(:group).description).to eq @desc
      end

      it 'should return the requested group' do
        patch :update, {format: 'json', id: @group.to_param, group: {description: @desc}}
        expect(assigns(:group)).to eq @group
      end

      it 'should render the show template' do
        patch :update, {format: 'json', id: @group.to_param, group: {description: @desc}}
        expect(response).to render_template :show
      end
    end

    describe 'with invalid params' do

      it 'should return a failure response' do
        patch :update, {format: 'json', id: @group.to_param, group: {description: ''}}
        expect(response.status).to eq 422
      end

      it 'should not update the group' do
        patch :update, {format: 'json', id: @group.to_param, group: {description: ''}}
        expect(@group.description).not_to eq ''
      end

      it 'should return errors' do
        patch :update, {format: 'json', id: @group.to_param, group: {description: ''}}
        expect(assigns(:group).errors).not_to be_nil
      end
    end
  end

  describe 'PATCH work with members' do

    before :each do
      @group = create :group
    end

    describe 'add account to group' do

      before :each do
        @account = create :account
      end

      it 'should return a valid response' do
        patch :add_members, {format: 'json', id: @group.to_param, group: {members: [@account.id]}}
        expect(response.status).to eq 200
      end

      it 'should create a new Membership' do
        expect {
          patch :add_members, {format: 'json', id: @group.to_param, group: {members: [@account.id]}}
        }.to change(Membership, :count).by(1)
      end

      it 'should return a failure response if the account does not exist' do
        patch :add_members, {format: 'json', id: @group.to_param, group: {members: [99]}}
        expect(response.status).to eq 400
      end
    end

    describe 'remove account from group' do

      before :each do
        @member_group = create :member_group
      end

      it 'should return a valid response' do
        patch :remove_members, {format: 'json', id: @member_group.group.to_param,
                                group: {members: [@member_group.account.to_param]}}
        expect(response.status).to eq 200
      end

      it 'should remove the requested account from the group' do
        expect {
          patch :remove_members, {format: 'json', id: @member_group.group.to_param,
                                  group: {members: [@member_group.account.to_param]}}
        }.to change(Membership, :count).by(-1)
      end

      it 'should return a failure response if the account does not exist' do
        patch :remove_members, {format: 'json', id: @member_group.group.to_param,
                                group: {members: [99]}}
        expect(response.status).to eq 400
      end
    end
  end

  describe 'DELETE destroy' do

    before :each do
      @group = create :group
    end

    it 'should return a valid response' do
      delete :destroy, {format: 'json', id: @group.to_param}
      expect(response.status).to eq 200
    end

    it 'destroys the requested account' do
      expect {
        delete :destroy, {format: 'json', id: @group.to_param}
      }.to change(Group, :count).by(-1)
    end
  end
end
