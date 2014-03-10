class Group < ActiveRecord::Base
  after_save :add_admin_to_group

  belongs_to :admin, class_name: Account

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :account

  has_many :technicians, dependent: :destroy
  has_many :techs, through: :technicians, source: :account

  validates :name,
            presence: true,
            uniqueness: {case_sensitive: false}

  validates :code,
            presence: true,
            uniqueness: {case_sensitive: false}

  validates :description, presence: true

  validates :admin, presence: true

  private

  def add_admin_to_group
    unless in_group?
      self.members << Account.find(admin_id)
    end
  end

  def in_group?
    self.members.include? Account.find(admin_id)
  end
end
