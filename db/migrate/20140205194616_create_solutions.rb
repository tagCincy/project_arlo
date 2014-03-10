class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.text :solution, null: false, default: ''
      t.boolean :accepted, default: false
      t.belongs_to :issue, null: false
      t.belongs_to :account, null: false

      t.timestamps
    end

    add_index :solutions, :issue_id
    add_index :solutions, :account_id
  end
end
