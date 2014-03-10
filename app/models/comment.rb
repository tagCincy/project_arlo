class Comment < ActiveRecord::Base
  belongs_to :account
  belongs_to :commentable, polymorphic: true

  validates_presence_of :comment, :commentable_id, :commentable_type
  validates_inclusion_of :commentable_type, in: %w(Issue Solution)

end
