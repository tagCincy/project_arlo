require 'spec_helper'

describe User do
  it 'should have a valid factory' do
    create(:user).should be_valid
  end
  
  it 'should require a first name' do
    build(:user, first_name: '').should_not be_valid
  end
  
  it 'should require a last name' do
    build(:user, last_name: '').should_not be_valid
  end

  it 'should require an email' do
    build(:user, email: '').should_not be_valid
  end

  it 'should require an unique email' do
    u = create :user
    build(:user, email: u.email).should_not be_valid
  end

  it 'should not accepted an upcased email that is not unique' do
    u = create :user
    build(:user, email: u.email.upcase).should_not be_valid
  end

  it 'should require a password' do
    build(:user, password: '').should_not be_valid
  end

  it 'should require a password confirmation' do
    build(:user, password_confirmation: '').should_not be_valid
  end

  it 'should not accept password confirmation mismatch' do
    build(:user, password_confirmation: 'Password1').should_not be_valid
  end
end
