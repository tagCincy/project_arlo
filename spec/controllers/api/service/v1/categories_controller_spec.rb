require 'spec_helper'

describe Api::Service::V1::CategoriesController do

  let(:valid_category) { create :category }
  let(:valid_attributes) { attributes_for :category }
  let(:invalid_attributes) { attributes_for(:category, name: '') }

  describe 'GET index' do

    before :each do
      @cats = Array(3..6).sample.times.map do
        create :category
      end
    end

    it 'should have a valid response' do
      get :index, {format: 'json'}
      expect(response.status).to eq 200
    end

    it 'should assign array of categories to @categories' do
      get :index, {format: 'json'}
      expect(assigns :categories).to eq @cats
    end
  end

  describe 'GET show' do

    before :each do
      @cat = create :category
    end

    it 'should have a valid response' do
      get :show, {format: 'json', id: @cat.to_param}
      expect(response.status).to eq 200
    end

    it 'should return the requested category' do
      get :show, {format: 'json', id: @cat.to_param}
      expect(assigns(:category)).to eq @cat
    end

    it 'should return a failure response if category is not found' do
      get :show, {format: 'json', id: 99}
      expect(response.status).to eq 400
    end

  end

  describe 'POST create' do

    describe 'with valid params' do

      it 'should have a valid response' do
        post :create, {format: 'json', category: valid_attributes}
        expect(response.status).to eq 201
      end

      it 'should create a new Category' do
        expect {
          post :create, {format: 'json', category: valid_attributes}
        }.to change(Category, :count).by 1
      end

      it 'should persist' do
        post :create, {format: 'json', category: valid_attributes}
        expect(assigns(:category)).to be_a Category
        expect(assigns(:category)).to be_persisted
      end

      it 'should render show template' do
        post :create, {format: 'json', category: valid_attributes}
        expect(response).to render_template :show
      end
    end

    describe 'with invalid params' do

      it 'should return a failure response' do
        post :create, {format: 'json', category: invalid_attributes}
        expect(response.status).to be 422
      end

      it 'should not create a Category' do
        expect {
          post :create, {format: 'json', category: invalid_attributes}
        }.not_to change(Category, :count)
      end

      it 'should return errors' do
        post :create, {format: 'json', category: invalid_attributes}
        expect(assigns(:category).errors).not_to be_nil
      end
    end
  end

  describe 'PATCH update' do

    describe 'with valid params' do

      before :each do
        @name = Faker::Lorem.word
      end

      it 'should return a valid response' do
        patch :update, {format: 'json', id: valid_category.to_param, category: {name: @name}}
        expect(response.status).to eq 200
      end

      it 'should update the requested category' do
        patch :update, {format: 'json', id: valid_category.to_param, category: {name: @name}}
        expect(assigns(:category).name).to eq @name
      end

      it 'should return the requested category' do
        patch :update, {format: 'json', id: valid_category.to_param, category: {name: @name}}
        expect(assigns(:category)).to eq valid_category
      end

      it 'should render show template' do
        patch :update, {format: 'json', id: valid_category.to_param, category: {name: @name}}
        expect(response).to render_template :show
      end
    end

    describe 'with invalid params' do

      before :each do
        @category = create :category
      end

      it 'should return a failure response' do
        patch :update, {format: 'json', id: @category.to_param, category: {name: ''}}
        expect(response.status).to eq 422
      end

      it 'should not update the category' do
        patch :update, {format: 'json', id: @category.to_param, category: {name: ''}}
        expect(@category.name).not_to eq ''
      end

      it 'should return errors' do
        patch :update, {format: 'json', id: @category.to_param, category: {name: ''}}
        expect(assigns(:category).errors).not_to be_nil
      end
    end
  end

  describe 'DELETE destroy' do

    before :each do
      @category = create :category
    end

    it 'should return a valid response' do
      delete :destroy, {format: 'json', id: @category.to_param}
      expect(response.status).to eq 200
    end

    it 'should reduce the category count' do
      expect {
        delete :destroy, {format: 'json', id: @category.to_param}
      }.to change(Category, :count).by(-1)
    end
  end
end
