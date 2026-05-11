class AddReminderSentToBorrowings < ActiveRecord::Migration[8.0]
  def change
    add_column :borrowings, :reminder_sent, :boolean, default: false
  end
end
