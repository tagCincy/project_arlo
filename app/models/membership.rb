class Membership < ActiveRecord::Base
  belongs_to :account, class_name: Account
  belongs_to :group, class_name: Group

  validates_uniqueness_of :account_id, scope: [:group_id]
  validates_uniqueness_of :group_id, scope: [:account_id]
end
