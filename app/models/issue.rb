class Issue < ActiveRecord::Base
  before_update :protected_attributes

  belongs_to :account
  has_many :issue_categories
  has_many :categories, through: :issue_categories, source: :category
  has_many :solutions
  has_many :comments, as: :commentable

  validates_presence_of :subject, :description, :categories

  private
  def protected_attributes
    false if subject_changed? || account_id_changed?
  end

end
