class CreateFines < ActiveRecord::Migration[8.1]
  def change
    create_table :fines do |t|
      t.references :borrowing, null: false, foreign_key: true
      t.decimal :amount_due
      t.decimal :amount_paid
      t.string :status

      t.timestamps
    end
  end
end
