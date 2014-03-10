require 'spec_helper'

describe Api::Service::V1::CommentsController do

  let(:valid_comment) { create :issue_comment }
  let(:valid_attributes) { attributes_for :comment }
  let(:invalid_attributes) { attributes_for(:comment, comment: '') }

  describe 'GET index' do

    describe 'issue comments' do
      before :each do
        @issue = create :issue
        @comments = Array(2..5).sample.times.map do
          create(:comment, commentable_id: @issue.id, commentable_type: 'Issue')
        end
      end

      it 'should have a valid response' do
        get :index, {format: 'json', issue_id: @issue.to_param}
        expect(response.status).to eq 200
      end

      it 'should return an array of issue comments' do
        get :index, {format: 'json', issue_id: @issue.to_param}
        expect(assigns(:comments)).to eq @comments
      end
    end

    describe 'solution comments' do
      before :each do
        @solution = create :solution
        @comments = Array(2..5).sample.times.map do
          create(:comment, commentable_id: @solution.id, commentable_type: 'Solution')
        end
      end

      it 'should have a valid response' do
        get :index, {format: 'json', solution_id: @solution.to_param}
        expect(response.status).to eq 200
      end

      it 'should return an array of solution comments' do
        get :index, {format: 'json', solution_id: @solution.to_param}
        expect(assigns(:comments)).to eq @comments
      end
    end

    describe 'invalid commentable' do

      it 'should not accept an invalid issue' do
        get :index, {format: 'json', issue_id: 3}
        expect(response.status).to eq 400
      end

      it 'should not accept an invalid solution' do
        get :index, {format: 'json', solution_id: 3}
        expect(response.status).to eq 400
      end
    end
  end

  describe 'GET show' do

    it 'should have a valid response' do
      get :show, {format: 'json', id: valid_comment.to_param}
      expect(response.status).to eq 200
    end

    it 'should return the requested comment' do
      get :show, {format: 'json', id: valid_comment.to_param}
      expect(assigns(:comment)).to eq valid_comment
    end

    it 'should return a failure response if comment is not found' do
      get :show, {format: 'json', id: 99}
      expect(response.status).to eq 400
    end

  end

  describe 'POST create' do

    before :each do
      @account = create :account
    end

    describe 'Issue Comment' do

      before :each do
        @issue = create :issue
      end

      describe 'with valid params' do

        it 'should return a valid response' do
          post :create, {format: 'json', issue_id: @issue.to_param, comment: valid_attributes.merge(account_id: @account.to_param)}
          expect(response.status).to eq 201
        end

        it 'creates a new Comment' do
          expect {
            post :create, {format: 'json', issue_id: @issue.to_param, comment: valid_attributes.merge(account_id: @account.to_param)}
          }.to change(Comment, :count).by(1)
        end

        it 'assigns a newly created comment as @comment' do
          post :create, {format: 'json', issue_id: @issue, comment: valid_attributes.merge(account_id: @account.to_param)}
          assigns(:comment).should be_a(Comment)
          assigns(:comment).should be_persisted
        end

        it 'should render the show template' do
          post :create, {format: 'json', issue_id: @issue.to_param, comment: valid_attributes.merge(account_id: @account.to_param)}
          expect(response).to render_template :show
        end
      end

      describe 'with invalid params' do

        it 'should return a failure response' do
          post :create, {format: 'json', issue_id: @issue, comment: invalid_attributes.merge(account_id: @account.to_param)}
          expect(response.status).to be 422
        end

        it 'should not create a Comment' do
          expect {
            post :create, {format: 'json', issue_id: @issue, comment: invalid_attributes.merge(account_id: @account.to_param)}
          }.not_to change(Comment, :count)
        end

        it 'should return errors' do
          post :create, {format: 'json', issue_id: @issue, comment: invalid_attributes.merge(account_id: @account.to_param)}
          expect(assigns(:comment).errors).not_to be_nil
        end
      end
    end

    describe 'Solution Comment' do

      before :each do
        @solution = create :solution
      end

      describe 'with valid params' do

        it 'should return a valid response' do
          post :create, {format: 'json', solution_id: @solution.to_param, comment: valid_attributes.merge(account_id: @account.to_param)}
          expect(response.status).to eq 201
        end

        it 'creates a new Comment' do
          expect {
            post :create, {format: 'json', solution_id: @solution.to_param, comment: valid_attributes.merge(account_id: @account.to_param)}
          }.to change(Comment, :count).by(1)
        end

        it 'assigns a newly created comment as @comment' do
          post :create, {format: 'json', solution_id: @solution, comment: valid_attributes.merge(account_id: @account.to_param)}
          assigns(:comment).should be_a(Comment)
          assigns(:comment).should be_persisted
        end

        it 'should render the show template' do
          post :create, {format: 'json', solution_id: @solution.to_param, comment: valid_attributes.merge(account_id: @account.to_param)}
          expect(response).to render_template :show
        end
      end

      describe 'with invalid params' do

        it 'should return a failure response' do
          post :create, {format: 'json', solution_id: @solution, comment: invalid_attributes.merge(account_id: @account.to_param)}
          expect(response.status).to be 422
        end

        it 'should not create a Comment' do
          expect {
            post :create, {format: 'json', solution_id: @solution, comment: invalid_attributes.merge(account_id: @account.to_param)}
          }.not_to change(Comment, :count)
        end

        it 'should return errors' do
          post :create, {format: 'json', solution_id: @solution, comment: invalid_attributes.merge(account_id: @account.to_param)}
          expect(assigns(:comment).errors).not_to be_nil
        end
      end
    end
  end

  describe 'PATCH update' do
    describe 'with valid params' do

      before :each do
        @comment = Faker::Lorem.paragraph
      end

      it 'should return a valid response' do
        patch :update, {format: 'json', id: valid_comment.to_param, comment: {comment: @comment}}
        expect(response.status).to eq 200
      end

      it 'should update the requested comment' do
        patch :update, {format: 'json', id: valid_comment.to_param, comment: {comment: @comment}}
        expect(assigns(:comment).comment).to eq @comment
      end

      it 'should render the show template' do
        patch :update, {format: 'json', id: valid_comment.to_param, comment: {comment: @comment}}
        expect(response).to render_template :show
      end
    end

    describe 'with invalid params' do

      before :each do
        @comment = create :issue_comment
      end

      it 'should return a failure response' do
        patch :update, {format: 'json', id: @comment.to_param, comment: {comment: ''}}
        expect(response.status).to eq 422
      end

      it 'should not update the comment' do
        patch :update, {format: 'json', id: @comment.to_param, comment: {comment: ''}}
        expect(@comment.comment).not_to eq ''
      end

      it 'should return errors' do
        patch :update, {format: 'json', id: @comment.to_param, comment: {comment: ''}}
        expect(assigns(:comment).errors).not_to be_nil
      end
    end
  end

  describe 'DELETE destroy' do

    before :each do
      @comment = create :issue_comment
    end

    it 'should return a valid response' do
      delete :destroy, {format: 'json', id: @comment.to_param}
      expect(response.status).to eq 200
    end

    it 'should reduce the comment count' do
      expect {
        delete :destroy, {format: 'json', id: @comment.to_param}
      }.to change(Comment, :count).by(-1)
    end
  end
end
