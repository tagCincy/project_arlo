require 'spec_helper'

describe Account do

  it 'should have a valid factory' do
    create(:account).should be_valid
  end

  describe 'validations' do

    it 'should require a handle' do
      build(:account, handle: '').should_not be_valid
    end

    it 'should require a unique handle' do
      a = create :account
      build(:account, handle: a.handle).should_not be_valid
    end

    it 'should not allow the same handle with different case' do
      a = create :account
      build(:account, handle: a.handle.upcase).should_not be_valid
    end
  end

  describe 'associations' do
    it 'should have a user' do
      create(:account).should belong_to :user
    end

    it 'should only allow user to have 1 account' do
      a = create :account
      build(:account, user: a.user).should_not be_valid
    end

    it 'should have a has_many relationship to MemberGroups through GroupMembers' do
      create(:account).should have_many(:member_groups).through(:memberships).source(:group)
    end

    it 'should have a has_many relationship to TechGroups through GroupTechs' do
      create(:account).should have_many(:tech_groups).through(:technicians).source(:group)
    end

    #it 'should have a has_many relationship to AdminGroups through GroupAdmins' do
    #  create(:account).should have_many(:admin_groups).through(:admins).source(:group)
    #end
  end
end