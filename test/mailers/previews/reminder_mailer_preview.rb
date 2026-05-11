# Preview all emails at http://localhost:3000/rails/mailers/reminder_mailer
class ReminderMailerPreview < ActionMailer::Preview
  def due_reminder
    member = Member.first || Member.create!(name: "Test Member", email: "member@example.com", membership_number: "MEM001")
    book = Book.second || Book.create!(title: "Test Book", isbn: "1234567890")
    borrowing = Borrowing.last || Borrowing.create!(member: member, book: book, due_date: Date.current + 3.days)

    ReminderMailer.with(member: member, book: book, borrowing: borrowing).due_reminder
  end
end
