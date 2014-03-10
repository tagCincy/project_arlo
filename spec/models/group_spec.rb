require 'spec_helper'

describe Group do
  it 'should have a valid factory' do
    create(:group).should be_valid
  end

  describe 'validations' do

    before :each do
      @group = create :group
    end

    it 'should be invalid without a name' do
      build(:group, name: '').should_not be_valid
    end

    it 'should be invalid without a unique name' do
      build(:group, name: @group.name ).should_not be_valid
    end

    it 'should be invalid with an upcased name' do
      build(:group, name: @group.name.upcase).should_not be_valid
    end

    it 'should be invalid without a code' do
      build(:group, code: '').should_not be_valid
    end

    it 'should be invalid without a unique code' do
      build(:group, code: @group.code).should_not be_valid
    end

    it 'should be invalid with an upcased code' do
      build(:group, code: @group.code.upcase).should_not be_valid
    end

    it 'should be invalid without a description' do
      build(:group, description: '').should_not be_valid
    end

    it 'should be invalid without an admin' do
      build(:group, admin: nil).should_not be_valid
    end
  end

  describe 'associations' do

    it 'should belong to a admin' do
      should belong_to :admin
    end

    it 'should have an admin of type Account' do
      create(:group).admin.should be_a Account
    end

    it 'should have a valid user group factory' do
      create(:member_group).should be_valid
    end
  end
end

