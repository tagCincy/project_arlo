class Account < ActiveRecord::Base
  belongs_to :user, dependent: :destroy

  has_many :memberships, dependent: :destroy
  has_many :member_groups, through: :memberships, source: :group

  has_many :technicians, dependent: :destroy
  has_many :tech_groups, through: :technicians, source: :group

  has_many :issues
  has_many :solutions
  has_many :comments
  has_many :groups

  accepts_nested_attributes_for :user

  validates :handle,
            presence: true,
            uniqueness: {case_sensitive: false}

  validates :user,
            presence: true,
            uniqueness: true
end
