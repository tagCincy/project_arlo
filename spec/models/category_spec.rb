require 'spec_helper'

describe Category do

  describe 'validations' do

    it 'should have a valid factory' do
      create(:category).should be_valid
    end

    it 'should be invalid without a name' do
      build(:category, name: '').should_not be_valid
    end

    it 'should be invalid without a unique name' do
      category = create :category
      build(:category, name: category.name).should_not be_valid
    end

    it 'should be invalid with a non-unique upcased name' do
      category = create :category
      build(:category, name: category.name.upcase).should_not be_valid
    end

    it 'should be invalid without a description' do
      build(:category, description: '').should_not be_valid
    end

  end

  describe 'associations' do

  end
end
