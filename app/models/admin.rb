class Admin < ActiveRecord::Base

  belongs_to :account, class_name: Account
  belongs_to :group, class_name: Group

  validate :is_admin_account


  def is_admin_account
    account = Account.find(account_id)
    unless account.admin
      errors.add(:admin, 'cannot add non-admin to Admin Group')
    end
  end
end
