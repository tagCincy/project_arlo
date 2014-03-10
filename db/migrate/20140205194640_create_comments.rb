class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :comment, null: false, default: ''
      t.belongs_to :account, null: false
      t.references :commentable, polymorphic: true

      t.timestamps
    end

    add_index :comments, :account_id
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
