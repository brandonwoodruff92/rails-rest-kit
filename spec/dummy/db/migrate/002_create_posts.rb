class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.belongs_to :user, null: false
      t.string :title, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end