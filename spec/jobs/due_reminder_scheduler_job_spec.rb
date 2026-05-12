require 'rails_helper'

RSpec.describe DueReminderSchedulerJob, type: :job do
  it "enqueues DueReminderJob" do
    create(:borrowing,
      status: "active",
      reminder_sent: false,
      due_date: 3.days.from_now.to_date
    )

    expect {
      described_class.perform_now
    }.to have_enqueued_job(DueReminderJob)
  end
end
