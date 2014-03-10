class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :subject, null: false, default: ''
      t.text :description, null: false, default: ''
      t.belongs_to :account, null: false

      t.timestamps
    end

    add_index :issues, :account_id
  end
end
