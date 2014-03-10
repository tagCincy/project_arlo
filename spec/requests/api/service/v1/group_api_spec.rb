require 'spec_helper'

describe 'Group API' do

  describe 'GET /api/service/v1/groups' do

    before do
      @groups = create_list(:group, 20)
      get '/api/service/v1/groups'
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

    it 'should return an array of groups' do
      expect(json['groups']).to be_a Array
    end

    it 'should return 20 groups' do
      expect(json['groups'].length).to eq 20
    end

    it 'should have group nodes' do
      expect(json['groups'][1]['group']).not_to be_nil
    end
  end

  describe 'GET /api/service/v1/groups/:id' do

    before do
      @group = create :group
      get "/api/service/v1/groups/#{@group.to_param}"
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

    it 'should return the requested group' do
      @admin_handle = Account.find(@group.admin_id).handle
      expect(json['group']['name']).to eq @group.name
      expect(json['group']['code']).to eq @group.code
      expect(json['group']['description']).to eq @group.description
      expect(json['group']['admin']).to eq @admin_handle
    end
  end

  describe 'POST /api/service/v1/groups' do

    before do
      @group = attributes_for :group_params
      post '/api/service/v1/groups', {group: @group}
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

    it 'should return the created group' do
      @admin_handle = Account.find(@group[:admin_id]).handle
      expect(json['group']['name']).to eq @group[:name]
      expect(json['group']['code']).to eq @group[:code]
      expect(json['group']['description']).to eq @group[:description]
      expect(json['group']['admin']).to eq @admin_handle
    end
  end

  describe 'PATCH /api/service/v1/groups/:id' do

    before do
      @group = create :group
      @description = Faker::Lorem.sentence
      patch "/api/service/v1/groups/#{@group.to_param}", {group: {description: @description}}
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

    it 'should return the updated group' do
      @admin_handle = Account.find(@group.admin_id).handle
      expect(json['group']['name']).to eq @group.name
      expect(json['group']['code']).to eq @group.code
      expect(json['group']['description']).to eq @description
      expect(json['group']['admin']).to eq @admin_handle
    end
  end

  describe 'DELETE /api/service/v1/groups/:id' do

    before do
      @group = create :group
      delete "/api/service/v1/groups/#{@group.to_param}"
    end

    it 'should return a valid response' do
      expect(response.status).to eq 200
    end

    it 'should delete the requested group from the db' do
      get "/api/service/v1/groups/#{@group.to_param}"
      expect(response.status).to eq 400
    end
  end

  describe 'PUT /api/service/v1/groups/:id/addMember' do

    before do
      @group = create :group
      @account = create :account
      put "/api/service/v1/groups/#{@group.to_param}/addMember", {group: {members: [@account.to_param]}}
    end

    it 'should return a valid response' do
      expect(response.status).to eq 200
    end

    it 'should add the member to the group' do
      members = Group.find(@group.id).members
      expect(members).to include @account
    end
  end

  describe 'PUT /api/service/v1/groups/:id/removeMember' do

    before do
      @membership = create :member_group
      put "/api/service/v1/groups/#{@membership.group_id}/removeMember",
          {group: {members: [@membership.account_id]}}
    end

    it 'should return a valid response' do
      expect(response.status).to eq 200
    end

    it 'should remove the group from the group' do
      members = Group.find(@membership.group_id).members
      account = Account.find(@membership.account_id)
      expect(members).not_to include account
    end
  end
end