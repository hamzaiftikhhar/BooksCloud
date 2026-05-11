# this clas will store the job in the redis after quering the database
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
      # 1)Active Job serializes the job data, 2) then converts borrowing into an ID, 3) Pushes job payload into Redis queue, 4)Sidekiq later fetches it
      # {
      #   "job_class":"DueReminderJob",
      #   "arguments":[12],   // 12 is the borrowing.id
      #   "queue":"default"
      # }
    end
  end
end

# it will do

# finds borrowings due in 3 days
# creates background email jobs
# Sidekiq processes them
