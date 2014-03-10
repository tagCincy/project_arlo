class Category < ActiveRecord::Base
  has_many :issue_categories
  has_many :issues, through: :issue_categories, source: :issue

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :description, presence: true

end
