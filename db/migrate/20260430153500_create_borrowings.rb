class CreateBorrowings < ActiveRecord::Migration[8.1]
  def change
    create_table :borrowings do |t|
      t.references :member, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.datetime :issue_date
      t.datetime :due_date
      t.datetime :return_date
      t.integer :status
      t.float :fine_amount, default: 0
      t.boolean :fine_paid, default: false

      t.timestamps
    end
  end
end
