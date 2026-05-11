require 'rails_helper'

RSpec.describe DueReminderSchedulerJob, type: :job do
  it "updates reminder_sent to true" do
    borrowing = Borrowing.create!(
      status: "active",
      reminder_sent: false,
      due_date: 2.days.from_now
    )

    described_class.perform_now

    expect(borrowing.reload.reminder_sent).to eq(true)
  end
end
