class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :account, null: false
      t.belongs_to :group, null: false
      t.timestamps
    end

    add_index :memberships, :account_id
    add_index :memberships, :group_id
  end
end
