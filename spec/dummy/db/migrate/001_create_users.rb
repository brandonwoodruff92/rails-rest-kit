class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false

      t.timestamps
    end
    
    add_index :users, :email, unique: true
  end
end