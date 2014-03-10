require 'spec_helper'

describe Solution do

  describe 'validations' do
    it 'should have a valid factory' do
      create(:solution).should be_valid
    end

    it 'should be invalid without a solution' do
      build(:solution, solution: '').should_not be_valid
    end
  end

  describe 'associations' do

    it 'should be invalid without an account' do
      create(:solution).should belong_to :account
    end

    it 'should have have an owner with type Account' do
      solution = create :solution
      expect(solution.account).to be_a Account
    end

    it 'should be invalid without an issue' do
      create(:solution).should belong_to :issue
    end

    it 'should have an associated issue with type Issue' do
      solution = create :solution
      expect(solution.issue).to be_a Issue
    end
  end

end
