class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :handle, null: false, default: ''
      t.string :description
      t.belongs_to :user, null: false
      t.boolean :technician, default: false
      #t.boolean :admin, default: false

      t.timestamps
    end

    add_index :accounts, :handle, unique: true
    add_index :accounts, :user_id, unique: true

  end
end
