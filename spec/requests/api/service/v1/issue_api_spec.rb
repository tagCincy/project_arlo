require 'spec_helper'

describe 'Issue API' do

  describe 'GET /api/service/v1/issues' do

    before do
      @issues = create_list(:issue, 20)
      get '/api/service/v1/issues'
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

    it 'should return an array of issues' do
      expect(json['issues']).to be_a Array
    end

    it 'should return 20 issues' do
      expect(json['issues'].length).to eq 20
    end

    it 'should have issue nodes' do
      expect(json['issues'][1]['issue']).not_to be_nil
    end
  end

  describe 'GET /api/service/v1/issues/:id' do

    before do
      @issue = create :full_issue
      get "/api/service/v1/issues/#{@issue.to_param}"
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

    it 'should return the requested issue' do
      expect(json['issue']['subject']).to eq @issue.subject
      expect(json['issue']['description']).to eq @issue.description
      expect(json['issue']['author']).to eq @issue.account.handle
      expect(json['issue']['categories']).to match_array @issue.categories.map { |c| {"name" => c.name} }
      expect(json['issue']['comments']).to match_array @issue.comments.map {
          |c| {"comment" => c.comment, "commenter" => c.account.handle} }
      #expect(json['issue']['solutions']).to match_array @issue.solutions.map {
      #  |s| {"solution" => s.solution, "technician" => s.account.handle, "comments" => s.comments.map {
      #    |c| {"comment" => c.comment, "commenter" => c.account.handle}
      #  }}
      #}
    end
  end

  describe 'POST /api/service/v1/issues' do

    before do
      @issue = attributes_for :issue_params
      post '/api/service/v1/issues', {issue: @issue}
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

    it 'should return the created issue' do
      expect(json['issue']['subject']).to eq @issue[:subject]
      expect(json['issue']['description']).to eq @issue[:description]
      expect(json['issue']['author']).to eq Account.find(@issue[:account_id]).handle
      expect(json['issue']['categories']).to match_array @issue[:category_ids].map { |c| {"name" => Category.find(c).name} }
    end
  end


  describe 'PATCH /api/service/v1/issues/:id' do

    before do
      @issue = create :issue
      @description = Faker::Lorem.paragraph
      patch "/api/service/v1/issues/#{@issue.to_param}", {issue: {description: @description}}
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

    it 'should return the updated issue' do
      expect(json['issue']['subject']).to eq @issue.subject
      expect(json['issue']['description']).to eq @description
      expect(json['issue']['author']).to eq @issue.account.handle
      expect(json['issue']['categories']).to match_array @issue.categories.map { |c| {"name" => c.name} }
    end
  end

  describe 'DELETE /api/service/v1/issues/:id' do

    before do
      @issue = create :issue
      delete "/api/service/v1/issues/#{@issue.to_param}"
    end

    it 'should return a valid response' do
      expect(response.status).to eq 200
    end

    it 'should delete the requested issue from the db' do
      get "/api/service/v1/issues/#{@issue.to_param}"
      expect(response.status).to eq 400
    end
  end

  describe 'PUT /api/service/v1/issues/:id/addCategory' do

    before do
      @issue = create :issue
      @category = create :category
      put "/api/service/v1/issues/#{@issue.to_param}/addCategory", {issue: {category_ids: [@category.to_param]}}
    end

    it 'should return a valid response' do
      expect(response.status).to eq 200
    end

    it 'should add the group to the issue' do
      categories = Issue.find(@issue.id).categories
      expect(categories).to include @category
    end
  end

  describe 'PUT /api/service/v1/issues/:id/removeCategory' do

    before do
      @issue = create :issue
      @category = @issue.categories.first
      put "/api/service/v1/issues/#{@issue.to_param}/removeCategory",
          {issue: {category_ids: [@category.to_param]}}
    end

    it 'should return a valid response' do
      expect(response.status).to eq 200
    end

    it 'should remove the group from the issue' do
      categories = Issue.find(@issue.id).categories
      expect(categories).not_to include @category
    end
  end

  describe 'GET /api/service/v1/issues/:id/comments' do
    before do
      @issue = create :full_issue
      get "/api/service/v1/issues/#{@issue.to_param}/comments"
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

    it 'should return an array of comments' do
      expect(json['comments']).to match_array @issue.comments.map { |c| {"comment" => c.comment, "commenter" => c.account.handle} }
    end
  end

  describe 'POST /api/service/v1/issues/:id/comments' do
    before do
      @issue = create :issue
      @comment = attributes_for :comment_params
      post "/api/service/v1/issues/#{@issue.to_param}/comments", {comment: @comment}
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

    it 'should return the created issue' do
      expect(json['comment']['comment']).to eq @comment[:comment]
      expect(json['comment']['commenter']).to eq Account.find(@comment[:account_id]).handle
    end

  end

  describe 'GET /api/service/v1/issues/:id/solutions' do
    before do
      @issue = create :full_issue
      get "/api/service/v1/issues/#{@issue.to_param}/solutions"
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

    it 'should return an array of solutions' do
      #expect(json['solutions']).to eq(@issue.solutions.map {
      #    |s| {"solution" => s.solution, "technician" => s.account.handle, "comments" => s.comments.map {
      #      |c| {"comment" => c.comment, "commenter" => c.account.handle} }}
      #})
    end
  end

  describe 'POST /api/service/v1/issues/:id/solutions' do
    before do
      @issue = create :issue
      @solution = attributes_for :solution_params
      post "/api/service/v1/issues/#{@issue.to_param}/solutions", {solution: @solution}
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

    it 'should return the created issue' do
      expect(json['solution']['solution']).to eq @solution[:solution]
      expect(json['solution']['technician']).to eq Account.find(@solution[:account_id]).handle
    end
  end
end