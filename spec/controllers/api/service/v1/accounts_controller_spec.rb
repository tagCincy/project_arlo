require 'spec_helper'

describe Api::Service::V1::AccountsController do
  let(:valid_account) { create :account }
  let(:valid_attributes) { attributes_for :account_params }
  let(:invalid_account_attributes) { attributes_for :invalid_account_params }
  let(:invalid_account_user_attributes) { attributes_for :invalid_account_user_params }

  describe 'GET index' do

    before :each do
      @accounts = Array(4..6).sample.times.map do
        create :account
      end
    end

    it 'should return a valid response' do
      get :index, {format: 'json'}
      expect(response.status).to eq 200
    end

    it 'should return an array of all accounts' do
      get :index, {format: 'json'}
      expect(assigns :accounts).to eq @accounts
    end
  end

  describe 'GET show' do

    it 'should have a valid response' do
      get :show, {format: 'json', id: valid_account.to_param}
      expect(response.status).to eq 200
    end

    it 'assigns the requested account as @account' do
      get :show, {format: 'json', id: valid_account.to_param}
      expect(assigns :account).to eq(valid_account)
    end

    it 'should return a failure response if the account is not found' do
      get :show, {format: 'json', id: 99}
      expect(response.status).to eq 400
    end
  end

  describe 'POST create' do

    describe 'with valid params' do

      it 'should return a valid response' do
        post :create, {format: 'json', account: valid_attributes}
        expect(response.status).to eq 201
      end

      it 'creates a new Account' do
        expect {
          post :create, {format: 'json', account: valid_attributes}
        }.to change(Account, :count).by(1)
      end

      it 'creates a new User' do
        expect {
          post :create, {format: 'json', account: valid_attributes}
        }.to change(User, :count).by(1)
      end

      it 'assigns a newly created account as @account' do
        post :create, {format: 'json', account: valid_attributes}
        expect(assigns :account).to be_a(Account)
        expect(assigns :account).to be_persisted
      end

      it 'assigns a newly created account.user as @account.user' do
        post :create, {format: 'json', account: valid_attributes}
        expect(assigns(:account).user).to be_a(User)
        expect(assigns(:account).user).to be_persisted
      end

      it 'should render the show template' do
        post :create, {format: 'json', account: valid_attributes}
        expect { response }.to render_template :show
      end

      #it 'should set the current user' do
      #  post :create, {format: 'json', account: valid_attributes}
      #  expect(assigns :current_user).not_to be_nil
      #end
    end

    describe 'with invalid params' do

      it 'should return a failure response' do
        post :create, {format: 'json', account: invalid_account_attributes}
        expect(response.status).to eq 422
      end

      it 'should not create a new Account' do
        expect {
          post :create, {format: 'json', account: invalid_account_attributes}
        }.not_to change(Account, :count)
      end

      it 'should not create a new User' do
        expect {
          post :create, {format: 'json', account: invalid_account_attributes}
        }.not_to change(User, :count)
      end

      it 'should return errors' do
        post :create, {format: 'json', account: invalid_account_attributes}
        expect(assigns(:account).errors).not_to be_nil
      end
    end
  end

  describe 'PATCH update' do

    before :each do
      @account = create :account
    end

    describe 'with valid params' do

      before :each do
        @handle = Faker::Internet.user_name
      end

      it 'should return a valid response' do
        patch :update, {format: :json, id: @account.to_param, account: {handle: @handle}}
        expect(response.status).to eq 200
      end

      it 'updates the requested account' do
        patch :update, {format: :json, id: @account.to_param, account: {handle: @handle}}
        expect(assigns(:account).handle).to eq @handle
      end

      it 'should return the requested account' do
        patch :update, {format: :json, id: @account.to_param, account: {handle: @handle}}
        expect(assigns(:account)).to eq @account
      end

      it 'should render the show template' do
        patch :update, {format: :json, id: @account.to_param, account: {handle: @handle}}
        expect { response }.to render_template :show
      end
    end

    describe 'with invalid params' do

      it 'should return a failure response' do
        patch :update, {format: 'json', id: @account.to_param, account: {handle: ''}}
        expect(response.status).to eq 422
      end

      it 'should not update the account' do
        patch :update, {format: 'json', id: @account.to_param, account: {handle: ''}}
        expect(@account.handle).not_to eq ''
      end

      it 'should return errors' do
        patch :update, {format: 'json', id: @account.to_param, account: {handle: ''}}
        expect(assigns(:account).errors).not_to be_nil
      end
    end
  end

  describe 'PATCH work with groups' do

    before :each do
      @account = create :account
    end

    describe 'adding accounts to groups' do

      before :each do
        @group = create :group
      end

      it 'should return a valid response' do
        patch :add_groups, {format: 'json', id: @account.to_param, account: {member_groups: [@group.to_param]}}
        expect(response.status).to eq 200
      end

      it 'adds group membership to an account' do
        expect {
          patch :add_groups, {format: 'json', id: @account.to_param, account: {member_groups: [@group.to_param]}}
        }.to change(Membership, :count).by(1)
      end

      it 'should return a failure response if the group does not exist' do
        patch :add_groups, {format: 'json', id: @account.to_param, account: {member_groups: [99]}}
        expect(response.status).to eq 400
      end
    end

    describe 'removing account from groups' do

      before :each do
        @member_group = create :member_group
      end

      it 'should return a valid response' do
        patch :remove_groups, {format: 'json', id: @member_group.account.to_param,
                               account: {member_groups: [@member_group.group.to_param]}}
        expect(response.status).to eq 200
      end

      it 'removes a group_membership from an account' do
        expect {
          patch :remove_groups, {format: 'json', id: @member_group.account.to_param,
                                 account: {member_groups: [@member_group.group.to_param]}}
        }.to change(Membership, :count).by(-1)
      end

      it 'should return a failure response if the group does not exist' do
        patch :remove_groups, {format: 'json', id: @member_group.account.to_param,
                               account: {member_groups: [99]}}
        expect(response.status).to eq 400
      end
    end
  end

  describe 'DELETE destroy' do

    before :each do
      @account = create :account
    end

    it 'should return a valid response' do
      delete :destroy, {format: :json, id: @account.to_param}
      expect(response.status).to eq 200
    end

    it 'destroys the requested account' do
      expect {
        delete :destroy, {format: :json, id: @account.to_param}
      }.to change(Account, :count).by(-1)
    end

    it 'destroys the requested accounts user' do
      expect {
        delete :destroy, {format: :json, id: @account.to_param}
      }.to change(User, :count).by(-1)
    end
  end
end
