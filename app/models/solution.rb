class Solution < ActiveRecord::Base
  belongs_to :issue
  belongs_to :account
  has_many :comments, as: :commentable

  validates_presence_of :solution
end
