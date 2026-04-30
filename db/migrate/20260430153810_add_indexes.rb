class AddIndexes < ActiveRecord::Migration[8.1]
  def change
    add_index :users, :email, unique: true
    add_index :members, :email, unique: true
    add_index :members, :membership_number, unique: true
    add_index :books, :isbn, unique: true
  end
end
