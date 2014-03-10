require 'spec_helper'

describe SessionsController do

  describe 'POST login' do

    before :each do
      account = create :account
      @user = account.user
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    it 'should return a valid response' do
      post :create, {format: 'json', user: {email: @user.email, password: @user.password}}
      expect(response.status).to eq 200
    end

    #it 'should return success message' do
    #  post :create, {format: 'json', user: {email: @user.email, password: @user.password}}
    #  expect(json['success']).to be_true
    #  expect(json['info']).to eq 'Logged in'
    #end
  end
end
