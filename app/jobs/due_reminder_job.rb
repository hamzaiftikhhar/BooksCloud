# this class will run, after the sidekiq worker will pull job from the Redis
class DueReminderJob < ApplicationJob
  queue_as :default

  def perform(borrowing)
    ReminderMailer
      .with(member: borrowing.member, book: borrowing.book, borrowing: borrowing)
      .due_reminder
      .deliver_now

    borrowing.update!(reminder_sent: true)
  end
end
