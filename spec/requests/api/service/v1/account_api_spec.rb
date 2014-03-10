require 'spec_helper'

describe 'Account API' do

  describe 'GET /api/service/v1/accounts' do

    before do
      @accounts = create_list(:account, 20)
      get '/api/service/v1/accounts'
    end

    it 'should be a valid request' do
      expect(response.status).to eq 200
    end

    it 'should return json' do
      expect(response.content_type).to eq 'application/json'
    end

    it 'should return parseable JSON' do
      expect(JSON.parse(response.body)).to be_true
    end

    it 'should return an array of accounts' do
      expect(json['accounts']).to be_a Array
    end

    it 'should return 20 accounts' do
      expect(json['accounts'].length).to eq 20
    end

    it 'should have account nodes' do
      expect(json['accounts'][1]['account']).not_to be_nil
    end
  end

  describe 'GET /api/service/v1/accounts/:id' do

    before do
      @account = create :account
      get "/api/service/v1/accounts/#{@account.to_param}"
    end

    it 'should be a valid request' do
      expect(response.status).to eq 200
    end

    it 'should return json' do
      expect(response.content_type).to eq 'application/json'
    end

    it 'should return parseable JSON' do
      expect(json).not_to be_nil
    end

    it 'should return the requested account' do
      expect(json['account']['first_name']).to eq @account.user.first_name
      expect(json['account']['last_name']).to eq @account.user.last_name
      expect(json['account']['email']).to eq @account.user.email
      expect(json['account']['handle']).to eq @account.handle
      expect(json['account']['description']).to eq @account.description
      expect(json['account']['technician']).to eq @account.technician
    end
  end

  describe 'POST /api/service/v1/accounts' do

    before do
      @account = attributes_for :account_params
      post '/api/service/v1/accounts', {account: @account}
    end

    it 'should return a valid response' do
      expect(response.status).to eq 201
    end

    it 'should return json' do
      expect(response.content_type).to eq 'application/json'
    end

    it 'should return parseable json' do
      expect(json).not_to be_nil
    end

    it 'should return the created account' do
      expect(json['account']['first_name']).to eq @account[:user_attributes][:first_name]
      expect(json['account']['last_name']).to eq @account[:user_attributes][:last_name]
      expect(json['account']['email']).to eq @account[:user_attributes][:email]
      expect(json['account']['handle']).to eq @account[:handle]
      expect(json['account']['description']).to eq @account[:description]
      expect(json['account']['technician']).to be_false
    end
  end

  describe 'PATCH /api/service/v1/accounts/:id' do

    before do
      @account = create :account
      @handle = Faker::Internet.user_name
      patch "/api/service/v1/accounts/#{@account.to_param}", {account: {handle: @handle}}
    end

    it 'should return a valid response' do
      expect(response.status).to eq 200
    end

    it 'should return json' do
      expect(response.content_type).to eq 'application/json'
    end

    it 'should return parseable json' do
      expect(json).not_to be_nil
    end

    it 'should return the updated account' do
      expect(json['account']['first_name']).to eq @account.user.first_name
      expect(json['account']['last_name']).to eq @account.user.last_name
      expect(json['account']['email']).to eq @account.user.email
      expect(json['account']['handle']).to eq @handle
      expect(json['account']['description']).to eq @account.description
      expect(json['account']['technician']).to eq @account.technician
    end
  end

  describe 'DELETE /api/service/v1/accounts/:id' do

    before do
      @account = create :account
      delete "/api/service/v1/accounts/#{@account.to_param}"
    end

    it 'should return a valid response' do
      expect(response.status).to eq 200
    end

    it 'should delete the requested account from the db' do
      get "/api/service/v1/accounts/#{@account.to_param}"
      expect(response.status).to eq 400
    end
  end

  describe 'PUT /api/service/v1/accounts/:id/addGroup' do

    before do
      @account = create :account
      @group = create :group
      put "/api/service/v1/accounts/#{@account.to_param}/addGroup", {account: {member_groups: [@group.to_param]}}
    end

    it 'should return a valid response' do
      expect(response.status).to eq 200
    end

    it 'should add the group to the account' do
      account_groups = Account.find(@account.id).member_groups
      expect(account_groups).to include @group
    end
  end

  describe 'PUT /api/service/v1/accounts/:id/removeGroup' do

    before do
      @membership = create :member_group
      put "/api/service/v1/accounts/#{@membership.account_id}/removeGroup",
          {account: {member_groups: [@membership.group_id]}}
    end

    it 'should return a valid response' do
      expect(response.status).to eq 200
    end

    it 'should remove the group from the account' do
      account_groups = Account.find(@membership.account_id).member_groups
      group = Group.find(@membership.group_id)
      expect(account_groups).not_to include group
    end

  end
end