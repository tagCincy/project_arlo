require 'spec_helper'

describe Issue do

  describe 'validations' do

    it 'should have a valid factory' do
      create(:issue).should be_valid
    end

    it 'should be invalid without a subject' do
      build(:issue, subject: '').should_not be_valid
    end

    it 'should be invalid without a description' do
      build(:issue, description: '').should_not be_valid
    end

  end

  describe 'associations' do

    it 'should be invalid without an account' do
      create(:issue).should belong_to :account
    end

    it 'should have have an owner with type Account' do
      issue = create :issue
      expect(issue.account).to be_a Account
    end

    it 'should be invalid without any categories' do
      build(:issue, categories: []).should_not be_valid
    end

    it 'should have a category with type Category' do
      issue = create :issue
      expect(issue.categories.first).to be_a Category
    end

  end
end
