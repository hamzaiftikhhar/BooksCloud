require "rails_helper"

RSpec.describe DueReminderJob, type: :job do
  describe "#perform" do
    it "sends reminder email and marks borrowing as reminder_sent" do
      member = create(:member, name: "Ali")
      book = create(:book)

      borrowing = create(
        :borrowing,
        member: member,
        book: book,
        reminder_sent: false
      )


      mailer_double = double # Fake mailer that behaves like real mailer, but does NOT send email
      allow(ReminderMailer).to receive(:with).and_return(mailer_double)
      allow(mailer_double).to receive(:due_reminder).and_return(mailer_double)
      allow(mailer_double).to receive(:deliver_now)

      described_class.perform_now(borrowing)

      expect(ReminderMailer).to have_received(:with).with(
        member: member,
        book: book,
        borrowing: borrowing
      )

      expect(mailer_double).to have_received(:due_reminder)
      expect(mailer_double).to have_received(:deliver_now)

      expect(borrowing.reload.reminder_sent).to eq(true) # expecting "reminder_sent" to be true
    end
  end
end
