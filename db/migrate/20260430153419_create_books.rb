class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :isbn
      t.string :genre
      t.text :description
      t.integer :total_copy_count
      t.integer :available_copy_count
      t.date :publication_date
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
