require 'spec_helper'

describe Api::Service::V1::SolutionsController do

  let(:valid_solution) { create :solution }
  let(:valid_attributes) { attributes_for(:solution) }
  let(:invalid_attributes) { attributes_for(:solution, solution: '') }

  describe 'GET index' do

    before :each do
      @issue = create :issue
      @solutions = Array(3..6).sample.times.map do
        create(:solution, issue_id: @issue.id)
      end
    end

    it 'should have a valid response' do
      get :index, {format: 'json', issue_id: @issue.to_param}
      expect(response.status).to eq 200
    end

    it 'should return an array of solutions' do
      get :index, {format: 'json', issue_id: @issue.to_param}
      expect(assigns(:solutions)).to eq @solutions
    end

    it 'should fail without a valid issue id' do
      get :index, {format: 'json', issue_id: 99}
      expect(response.status).to eq 400
    end

  end

  describe 'GET show' do

    it 'should have a valid response' do
      get :show, {format: 'json', id: valid_solution.to_param}
      expect(response.status).to eq 200
    end

    it 'should return the requested solution' do
      get :show, {format: 'json', id: valid_solution.to_param}
      expect(assigns(:solution)).to eq valid_solution
    end

    it 'should return a failure response if solution is not found' do
      get :show, {format: 'json', id: 99}
      expect(response.status).to eq 400
    end

  end

  describe 'POST create' do

    before :each do
      @issue = create :issue
      @account = create :account
    end

    describe 'with valid params' do

      it 'should have a valid response' do
        post :create, {format: 'json', issue_id: @issue.to_param, solution: valid_attributes.merge(account_id: @account.id)}
        expect(response.status).to eq 201
      end

      it 'should create a new solution' do
        expect {
          post :create, {format: 'json', issue_id: @issue.to_param, solution: valid_attributes.merge(account_id: @account.id)}
        }.to change(Solution, :count).by 1
      end

      it 'should persist' do
        post :create, {format: 'json', issue_id: @issue.to_param, solution: valid_attributes.merge(account_id: @account.id)}
        expect(assigns :solution).to be_a Solution
        expect(assigns :solution).to be_persisted
      end

      it 'should render the show template' do
        post :create, {format: 'json', issue_id: @issue.to_param, solution: valid_attributes.merge(account_id: @account.id)}
        expect(response).to render_template :show
      end
    end

    describe 'with invalid params' do

      it 'should return a failure response' do
        post :create, {format: 'json', issue_id: @issue.to_param, solution: invalid_attributes.merge(account_id: @account.id)}
        expect(response.status).to eq 422
      end

      it 'should not create a new solution' do
        expect {
          post :create, {format: 'json', issue_id: @issue.to_param, solution: invalid_attributes.merge(account_id: @account.id)}
        }.not_to change(Solution, :count)
      end

      it 'should return errors' do
        post :create, {format: 'json', issue_id: @issue.to_param, solution: invalid_attributes.merge(account_id: @account.id)}
        expect(assigns(:solution).errors).not_to be_nil
      end

    end

  end

  describe 'PATCH update' do

    before :each do
      @solution = create :solution
    end

    describe 'with valid params' do

      before :each do
        @solution_text = Faker::Lorem.paragraph
      end

      it 'should have a valid response' do
        patch :update, {format: 'json', id: @solution.to_param, solution: {solution: @solution_text}}
        expect(response.status).to eq 200
      end

      it 'should update the requested solution' do
        patch :update, {format: 'json', id: @solution.to_param, solution: {solution: @solution_text}}
        expect(assigns(:solution).solution).to eq @solution_text
      end

      it 'should return the requested solution' do
        patch :update, {format: 'json', id: @solution.to_param, solution: {solution: @solution_text}}
        expect(assigns :solution).to eq @solution
      end

      it 'should render the show template' do
        patch :update, {format: 'json', id: @solution.to_param, solution: {solution: @solution_text}}
        expect(response).to render_template :show
      end
    end

    describe 'with invalid params' do

      it 'should return a failure response' do
        patch :update, {format: 'json', id: @solution.to_param, solution: {solution: ''}}
        expect(response.status).to eq 422
      end

      it 'should not update the requested solution' do
        patch :update, {format: 'json', id: @solution.to_param, solution: {solution: ''}}
        expect(@solution.solution).not_to eq ''
      end

      it 'should return errors' do
        patch :update, {format: 'json', id: @solution.to_param, solution: {solution: ''}}
        expect(assigns(:solution).errors).not_to be_nil
      end

    end
  end

  describe 'DELETE destroy' do

    before :each do
      @solution = create :solution
    end

    it 'should have a valid response' do
      delete :destroy, {format: 'json', id: @solution.to_param}
      expect(response.status).to be 200
    end

    it 'should delete the solution' do
      expect {
        delete :destroy, {format: 'json', id: @solution.to_param}
      }.to change(Solution, :count).by(-1)
    end

  end
end
