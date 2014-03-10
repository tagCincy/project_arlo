class CreateTechnicians < ActiveRecord::Migration
  def change
    create_table :technicians do |t|
      t.belongs_to :account, null: false
      t.belongs_to :group, null: false
      t.timestamps
    end

    add_index :technicians, :account_id
    add_index :technicians, :group_id
  end
end
