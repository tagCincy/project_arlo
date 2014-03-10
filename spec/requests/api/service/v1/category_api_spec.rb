require 'spec_helper'

describe 'Category API' do

  describe 'GET /api/service/v1/categories' do

    before do
      @categories = create_list(:category, 20)
      get '/api/service/v1/categories'
    end

    it 'should have a valid response' do
      expect(response.status).to eq 200
    end

    it 'should return json' do
      expect(response.content_type).to eq 'application/json'
    end

    it 'should return parseable json' do
      expect(JSON.parse(response.body)).to be_true
    end

    it 'should return an array of categories' do
      expect(json['categories']).to be_a Array
    end

    it 'should return 20 categories' do
      expect(json['categories'].length).to eq 20
    end

    it 'should have category nodes' do
      expect(json['categories'][1]['category']).not_to be_nil
    end

  end

  describe 'GET /api/service/v1/categories/:id' do
    before do
      @category = create :category
      get "/api/service/v1/categories/#{@category.to_param}"
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

    it 'should return the requested category' do
      expect(json['category']['name']).to eq @category.name
      expect(json['category']['description']).to eq @category.description
    end
  end

  describe 'POST /api/service/v1/categories' do

    before do
      @category = attributes_for :category
      post '/api/service/v1/categories', {category: @category}
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

    it 'should return the created category' do
      expect(json['category']['name']).to eq @category[:name]
      expect(json['category']['description']).to eq @category[:description]
    end
  end

  describe 'PATCH /api/service/v1/categories/:id' do
    before do
      @category = create :category
      @description = Faker::Lorem.sentence
      patch "/api/service/v1/categories/#{@category.to_param}", {category: {description: @description}}
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

    it 'should return the updated category' do
      expect(json['category']['name']).to eq @category.name
      expect(json['category']['description']).to eq @description
    end
  end

  describe 'DELETE /api/service/v1/categories/:id' do
    before do
      @category = create :category
      delete "/api/service/v1/categories/#{@category.to_param}"
    end

    it 'should return a valid response' do
      expect(response.status).to eq 200
    end

    it 'should delete the requested category from the db' do
      get "/api/service/v1/categories/#{@category.to_param}"
      expect(response.status).to eq 400
    end
  end

end