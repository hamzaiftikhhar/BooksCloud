class ChangeGenreToIntegerInBooks < ActiveRecord::Migration[8.1]
  def change
    change_column :books, :genre, :integer, using: 'genre::integer' # using PostgreSQL casting.”
  end
end
