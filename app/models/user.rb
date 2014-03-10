class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :recoverable, :rememberable, :trackable, :validatable

  devise :database_authenticatable, :registerable

  has_one :account
  has_many :issues

  validates :first_name, presence: true

  validates :last_name, presence: true

  validates :email,
            uniqueness: {case_sensitive: true},
            presence: true

  validates :password,
            presence: true,
            confirmation: true

  validates :password_confirmation,
            presence: true

end
