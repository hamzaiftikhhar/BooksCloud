📚 Book Cloud

A modern Library Management System built with Ruby on Rails that streamlines book borrowing, member management, fines, and library operations with clean architecture and scalable design.

✨ Features

📖 Book Management

Add, update, and manage books
Track available copies in real-time
Automatic inventory updates on borrowing/return

👤 Member System

Member registration with unique membership numbers
Borrowing limits per member
Status control (active / suspended / expired)

🔄 Borrowing System

Issue and return books
Automatic due date calculation
Borrowing history tracking

⏰ Overdue Handling

Detect overdue borrowings
Calculate overdue duration
Support for fine generation

💰 Fine Management

Automatic fine tracking
Partial & full payments
Outstanding vs paid status

⚙️ Background Logic

Service object-based architecture
Clean separation of concerns
Transaction-safe operations

🧠 Tech Stack
🟣 Ruby 3.x
💎 Ruby on Rails 8+
🐘 PostgreSQL
🧪 RSpec (Testing)
🏭 FactoryBot
🔥 Shoulda Matchers
⚡ Sidekiq (if used for jobs)
📦 Redis (for background jobs / caching)
🏗️ Architecture Overview

This project follows a clean Rails architecture:

Models → Business Rules
Services → Complex Workflows
Controllers → Request Handling
Specs → Full Test Coverage
Key Design Decisions:
Service Objects for borrowing logic
Enum-based status handling
Delegation for clean associations
Transaction-safe database operations
Scopes for query optimization

📂 Project Structure

app/
├── controllers/
│   ├── admin/
│   │   ├── dashboard_controller.rb
│   │   └── users_controller.rb
│   ├── books_controller.rb
│   ├── authors_controller.rb
│   ├── members_controller.rb
│   ├── borrowings_controller.rb
│   ├── fines_controller.rb
│   ├── dashboard_controller.rb
│   ├── borrowing_history_controller.rb
│   └── reports/
│       └── dashboard_controller.rb
│
├── models/
│   ├── application_record.rb
│   ├── book.rb
│   ├── author.rb
│   ├── member.rb
│   ├── borrowing.rb
│   ├── fine.rb
│   ├── user.rb
│   └── concerns/
│
├── services/
│   ├── borrowing_service.rb
│   ├── return_service.rb
│   └── fine_calculation_service.rb
│
├── queries/
│   ├── book_search.rb
│   ├── most_borrowed_books_query.rb
│   ├── monthly_borrowing_count_query.rb
│   └── overdue_borrows_query.rb
│
├── jobs/
│   ├── due_reminder_job.rb
│   └── due_reminder_scheduler_job.rb
│
├── mailers/
│   ├── application_mailer.rb
│   └── reminder_mailer.rb
│
├── policies/
│   ├── application_policy.rb
│   ├── book_policy.rb
│   ├── member_policy.rb
│   ├── borrowing_policy.rb
│   └── fine_policy.rb
│
├── presenters/
│   └── report_presenter.rb
│
├── exceptions/
│   └── borrowing_errors.rb
│
├── constants/
│   └── library_constants.rb
│
├── javascript/
│   └── controllers/
│       ├── application.js
│       ├── index.js
│       └── author_search_controller.js
│
├── views/
│   ├── books/
│   ├── authors/
│   ├── members/
│   ├── borrowings/
│   ├── fines/
│   ├── dashboard/
│   ├── reports/
│   ├── borrowing_history/
│   ├── admin/
│   └── layouts/
│
├── assets/
│   ├── stylesheets/
│   └── images/
│
└── helpers/
    └── application_helper.rb


⚙️ Config & Infrastructure

config/
├── routes.rb
├── database.yml
├── puma.rb
├── schedule.yml
├── storage.yml
├── cable.yml
├── environments/
└── initializers/



🔄 Core Workflow

Borrow Book Flow
Member requests a book
BorrowingService validates:
Member status
Borrow limit
Book availability
Borrowing is created
Book inventory is reduced
Due date is set automatically


⚠️ Business Rules

❌ Suspended members cannot borrow
❌ Expired members cannot borrow
❌ Members cannot exceed borrow limit
❌ Books must have available copies
⏰ Overdue borrowings are tracked automatically


🧪 Testing

This project is fully tested using RSpec.

Run tests:
bundle exec rspec
Coverage includes:
Model validations
Associations
Scopes
Callbacks
Service objects
Business logic

📊 Example Domain Logic

Overdue Check
def overdue?
  return false unless due_date.present?
  return false if returned?

  Date.current > due_date
end
Borrow Limit Check
def can_borrow?
  active? && active_borrowings.count < max_books_allowed
end


🚀 Getting Started

1. Clone repo
git clone https://github.com/your-username/book-cloud.git
cd book-cloud
2. Install dependencies
bundle install
3. Setup database
rails db:create
rails db:migrate
rails db:seed
4. Run server
rails server


📌 Future Improvements
📲 Notification system (email/SMS reminders)
📈 Admin dashboard analytics
🔍 Advanced search filters
📦 Docker support
☁️ Cloud deployment (Render / AWS)
🔐 Role-based authorization improvements
👨‍💻 Author

Built with 💙 by a developer passionate about clean architecture and scalable backend systems.

⭐ If you like this project

Give it a star ⭐ and feel free to contribute or fork it.