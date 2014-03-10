class CreateIssueCategories < ActiveRecord::Migration
  def change
    create_table :issue_categories do |t|
      t.belongs_to :issue, null: false
      t.belongs_to :category, null: false

      t.timestamps
    end

    add_index :issue_categories, :issue_id
    add_index :issue_categories, :category_id
  end
end
