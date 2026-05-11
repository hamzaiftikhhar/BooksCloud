class DueReminderSchedulerJob < ApplicationJob
  queue_as :default

  def perform
    borrowings = Borrowing.where(status: "active", reminder_sent: false)
         .where("due_date <= ?", 3.days.from_now.to_date)

    if borrowings.empty?
      Rails.logger.info "⏱️ No due reminders found"
      return
    end

    borrowings.find_each do |borrowing|
      DueReminderJob.perform_later(borrowing)
      borrowing.update!(reminder_sent: true)
    end
  end
end

# it will do

# finds borrowings due in 3 days
# creates background email jobs
# Sidekiq processes them
