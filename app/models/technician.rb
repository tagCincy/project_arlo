class Technician < ActiveRecord::Base
  belongs_to :account, class_name: Account
  belongs_to :group, class_name: Group

  validate :is_technician_account


  def is_technician_account
    account = Account.find(account_id)
    unless account.technician?
      errors.add(:technician, 'cannot add non-technician to Technician Group')
    end
  end
end
