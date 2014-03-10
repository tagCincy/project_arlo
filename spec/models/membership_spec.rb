require 'spec_helper'

describe Membership do

  describe 'validations' do

    before :each do
      @account = create :account
      @group = create :group
      create(:member_group, account: @account, group: @group)
    end

    it 'should not allow duplicates' do
      expect(build(:member_group, account: @account, group: @group)).not_to be_valid
    end

    it 'allows an account to be in multiple groups' do
      group2 = create :group
      expect(build(:member_group, account: @account, group: group2)).to be_valid
    end

    it 'allows a group to have multiple members' do
      account2 = create :account
      expect(build(:member_group, account: account2, group: @group)).to be_valid
    end
  end

end