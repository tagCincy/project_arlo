class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, null: false, default: ''
      t.string :code, null: false, default: ''
      t.text :description, null: false, default: ''
      t.belongs_to :admin

      t.timestamps
    end

    add_index :groups, :name, unique: true
    add_index :groups, :code, unique: true
    add_index :groups, :admin_id
  end
end
