require 'spec_helper'

describe Api::Service::V1::IssuesController do

  let(:valid_issue) { create :issue }
  let(:valid_attributes) { attributes_for :issue_params }
  let(:invalid_attributes) { attributes_for :invalid_issue_params }

  describe 'GET index' do

    before :each do
      @issues = Array(3..6).sample.times.map do
        create :issue
      end
    end

    it 'returns a valid response' do
      get :index, {format: 'json'}
      expect(response.status).to eq 200
    end

    it 'returns an array of all the issues' do
      get :index, {format: 'json'}
      expect(assigns :issues).to eq(@issues)
    end

  end

  describe 'GET show' do

    before :each do
      @issue = create :issue
    end

    it 'should return a valid response' do
      get :show, {format: 'json', id: @issue.to_param}
      expect(response.status).to eq 200
    end

    it 'should assign requested issue to @issue' do
      get :show, {format: 'json', id: @issue.to_param}
      expect(assigns :issue).to eq @issue
    end

    it 'should return a valid response' do
      get :show, {format: 'json', id: 99}
      expect(response.status).to eq 400
    end
  end

  describe 'POST create' do

    before :each do
      @account = (create :account).id
      @categories = Array(1..4).sample.times.map { (create :category).id }
    end

    describe 'with valid params' do

      it 'should return a valid response' do
        post :create, {format: 'json', issue: valid_attributes.merge(account_id: @account, category_ids: @categories)}
        expect(response.status).to eq 201
      end

      it 'creates a new Issue' do
        expect {
          post :create, {format: 'json', issue: valid_attributes.merge(account_id: @account, category_ids: @categories)}
        }.to change(Issue, :count).by(1)
      end

      it 'assigns the new issue to @issue' do
        post :create, {format: 'json', issue: valid_attributes.merge(account_id: @account, category_ids: @categories)}
        expect(assigns :issue).to be_a Issue
        expect(assigns :issue).to be_persisted
      end

      it 'creates a new IssueCategory' do
        expect {
          post :create, {format: 'json', issue: valid_attributes.merge(account_id: @account, category_ids: @categories)}
        }.to change(IssueCategory, :count).by_at_least(1)
      end

      it 'associates the Issue with an category' do
        post :create, {format: 'json', issue: valid_attributes.merge(account_id: @account, category_ids: @categories)}
        expect(assigns(:issue).categories.sample).to be_a Category
      end

      it 'associates the Issue with an account' do
        post :create, {format: 'json', issue: valid_attributes.merge(account_id: @account, category_ids: @categories)}
        expect(assigns(:issue).account).to be_a Account
      end

      it 'should render the show template' do
        post :create, {format: 'json', issue: valid_attributes.merge(account_id: @account, category_ids: @categories)}
        expect(response).to render_template :show
      end
    end

    describe 'with invalid params' do

      it 'should return a failure response' do
        post :create, {format: 'json', issue: invalid_attributes.merge(account_id: @account, category_ids: @categories)}
        expect(response.status).to eq 422
      end

      it 'should fail without required issue params' do
        expect { post :create, {format: 'json', issue: invalid_attributes.merge(account_id: @account, category_ids: @categories)}
        }.to_not change(Issue, :count)
      end

      it 'should fail without a valid account' do
        expect {
          post :create, {format: 'json', issue: invalid_attributes.merge(category_ids: @categories)}
        }.to_not change(Issue, :count)
      end

      it 'should fail without any valid categories' do
        expect {
          post :create, {format: 'json', issue: invalid_attributes.merge(account_id: @account)}
        }.to_not change(Issue, :count)
      end

      it 'should return errors' do
        post :create, {format: 'json', issue: invalid_attributes.merge(account_id: @account, category_ids: @categories)}
        expect(assigns(:issue).errors).not_to be_nil
      end
    end
  end

  describe 'PATCH update' do

    before :each do
      @issue = create :issue
    end

    describe 'with valid params' do

      before :each do
        @desc = Faker::Lorem.paragraph
      end

      it 'should return a valid response' do
        patch :update, {format: :json, id: @issue.to_param, issue: {description: @desc}}
        expect(response.status).to eq 200
      end

      it 'updates the requested issue' do
        patch :update, {format: :json, id: @issue.to_param, issue: {description: @desc}}
        expect(assigns(:issue).description).to eq @desc
      end

      it 'assigns the requested issue as @issue' do
        patch :update, {format: :json, id: @issue.to_param, issue: {description: @desc}}
        expect(assigns :issue).to eq(@issue)
      end

      it 'should render the show template' do
        patch :update, {format: :json, id: @issue.to_param, issue: {description: @desc}}
        expect(response).to render_template :show
      end
    end

    describe 'with invalid params' do

      it 'should return a failure response' do
        patch :update, {format: :json, id: @issue, issue: {description: ''}}
        expect(response.status).to eq 422
      end

      it 'should not change the requested issue' do
        patch :update, {format: :json, id: @issue, issue: {description: ''}}
        expect(@issue.description).not_to eq ''
      end

      it 'does not allow the subject to be changed' do
        patch :update, {format: 'json', id: @issue.to_param, issue: {subject: 'This is a test'}}
        expect(response.status).to eq 422
      end

      it 'does not allow the account to be changed' do
        @account = create :account
        patch :update, {format: 'json', id: @issue.to_param, issue: {account_id: @account.id}}
        expect(response.status).to eq 422
      end

      it 'should return errors' do
        patch :update, {format: :json, id: @issue, issue: {description: ''}}
        expect(assigns(:issue).errors).not_to be_nil
      end
    end
  end

  describe 'PATCH update categories' do

    before :each do
      @issue = create :issue
    end

    describe 'add a category' do

      before :each do
        @category = create :category
      end

      it 'should return a valid response' do
        patch :add_category, {format: 'json', id: @issue.to_param, issue: {category_ids: [@category.to_param]}}
        expect(response.status).to eq 200
      end

      it 'should add a record to IssueCategory' do
        expect {
          patch :add_category, {format: 'json', id: @issue.to_param, issue: {category_ids: [@category.to_param]}}
        }.to change(IssueCategory, :count).by(1)
      end

      it 'should have added category included in @issue.categories' do
        patch :add_category, {format: 'json', id: @issue.to_param, issue: {category_ids: [@category.to_param]}}
        expect(assigns(:issue).categories).to include @category
      end
    end

    describe 'remove a category' do

      before :each do
        @category = @issue.categories.first
      end

      it 'should return a valid response' do
        patch :remove_category, {format: 'json', id: @issue.to_param, issue: {category_ids: [@category.to_param]}}
        expect(response.status).to eq 200
      end

      it 'should remove a record to IssueCategory' do
        expect {
          patch :remove_category, {format: 'json', id: @issue.to_param, issue: {category_ids: [@category.to_param]}}
        }.to change(IssueCategory, :count).by(-1)
      end

      it 'should not contain removed category in @issue.categories' do
        patch :remove_category, {format: 'json', id: @issue.to_param, issue: {category_ids: [@category.to_param]}}
        expect(assigns(:issue).categories).not_to include @category
      end
    end
  end

  describe 'DELETE destroy' do

    before :each do
      @issue = create :issue
    end

    it 'should return a valid response' do
      delete :destroy, {format: 'json', id: @issue.to_param}
      expect(response.status).to eq 200
    end

    it 'destroys the requested account' do
      expect {
        delete :destroy, {format: 'json', id: @issue.to_param}
      }.to change(Issue, :count).by(-1)
    end
  end
end
