class ReminderMailer < ApplicationMailer
  default from: "noreply@library.local"

  def due_reminder
    @member = params[:member]
    @book = params[:book]
    @borrowing = params[:borrowing]

    mail(
      to: @member.email,
      subject: "📚 Book Return Reminder (Due in 3 Days)"
    )
  end
end
