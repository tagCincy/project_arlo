require 'spec_helper'

describe Comment do

  describe 'validations' do

    it 'should have a valid factory' do
      create(:issue_comment).should be_valid
    end

    it 'should be invalid without a comment' do
      build(:issue_comment, comment: '').should_not be_valid
    end

    it 'should be invalid without a commentable_id' do
      build(:issue_comment, commentable_id: '').should_not be_valid
    end

    it 'should be invalid without a commentable_type' do
      build(:issue_comment, commentable_type: '').should_not be_valid
    end

    it 'should have a valid commentable_type' do
      build(:issue_comment, commentable_type: 'ABC').should_not be_valid
    end

  end

  describe 'associations' do

    it 'should be invalid without an account' do
      create(:issue_comment).should belong_to :account
    end

    it 'should have have an owner with type Account' do
      comment = create :issue_comment
      expect(comment.account).to be_a Account
    end

    it 'should belong to commentable' do
      create(:issue_comment).should belong_to :commentable
    end

    it 'should have commentable of type Issue' do
      comment = create :issue_comment
      expect(comment.commentable).to be_a Issue
    end

    it 'shoudl have commentable of type Solution' do
      comment = create :solution_comment
      expect(comment.commentable).to be_a Solution
    end

  end

end
