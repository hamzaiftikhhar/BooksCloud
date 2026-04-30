class CreateMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :members do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :membership_number
      t.integer :status
      t.integer :max_books_allowed, default: 3

      t.timestamps
    end
  end
end
