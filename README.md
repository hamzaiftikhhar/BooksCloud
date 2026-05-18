# 📚 Book Cloud

A modern **Library Management System** built with Ruby on Rails that streamlines book borrowing, member management, fines, and library operations using a clean, service-oriented architecture.

---

## ✨ Features

### 📖 Book Management
- Add, update, and manage books  
- Real-time tracking of available copies  
- Automatic inventory updates on borrow/return  

---

### 👤 Member System
- Member registration with unique membership numbers  
- Borrowing limits per member  
- Status control: active / suspended / expired  

---

### 🔄 Borrowing System
- Issue and return books  
- Automatic due date calculation  
- Full borrowing history tracking  

---

### ⏰ Overdue Handling
- Detect overdue borrowings automatically  
- Calculate overdue duration  
- Foundation for fine generation  

---

### 💰 Fine Management
- Automatic fine tracking  
- Partial and full payments supported  
- Status: outstanding / paid  

---

## ⚙️ Architecture Highlights

- Service Object pattern for business logic  
- Clean separation of concerns  
- Transaction-safe operations  
- Query objects for optimized reads  
- Enum-based state management  
- Delegation for cleaner associations  

---

## 🧠 Tech Stack

- Ruby 3.x  
- Ruby on Rails 8+  
- PostgreSQL  
- RSpec  
- FactoryBot  
- Shoulda Matchers  
- Sidekiq (background jobs)  
- Redis
- Advise
- Pundit
- AWS
- JS
- Bootstrap
- Ruby Gems 

---

## 🏗️ Architecture Overview

- **Models** → Business logic  
- **Services** → Complex workflows  
- **Controllers** → Request handling  
- **Queries** → Optimized database reads  
- **Jobs** → Background processing  
- **Policies** → Authorization rules  
- **Specs** → Full test coverage  

---

## 📂 Project Structure

```bash
app/
├── controllers/
│   ├── admin/
│   ├── books_controller.rb
│   ├── authors_controller.rb
│   ├── members_controller.rb
│   ├── borrowings_controller.rb
│   ├── fines_controller.rb
│   ├── dashboard_controller.rb
│   ├── borrowing_history_controller.rb
│   └── reports/
│
├── models/
│   ├── book.rb
│   ├── author.rb
│   ├── member.rb
│   ├── borrowing.rb
│   ├── fine.rb
│   └── user.rb
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
│   ├── book_policy.rb
│   ├── member_policy.rb
│   ├── borrowing_policy.rb
│   └── fine_policy.rb
│
├── presenters/
├── exceptions/
├── constants/
└── views/



🔄 Core Workflow

📘 Borrow Book Flow


Member requests a book
BorrowingService validates:
Member status
Borrow limit
Book availability
Borrowing record is created
Book inventory is updated
Due date is assigned automatically


⚠️ Business Rules
Suspended members cannot borrow
Expired members cannot borrow
Borrow limit must not be exceeded
Books must have available copies
Overdue borrowings are tracked automatically


🧪 Testing

Run tests:

bundle exec rspec
Includes:
Model validations
Associations
Scopes
Callbacks
Services
Business logic


📊 Sample Domain Logic
def overdue?
  return false unless due_date.present?
  return false if returned?

  Date.current > due_date
end
def can_borrow?
  active? && active_borrowings.count < max_books_allowed
end


🚀 Setup Instructions
git clone https://github.com/your-username/book-cloud.git
cd book-cloud
bundle install
rails db:create
rails db:migrate
rails db:seed
rails server


📌 Future Improvements
Email / SMS notifications
Docker support
Cloud deployment (AWS / Render)
Ai-powered Book recommendation


👨‍💻 Author

Built with 💙 by Hamza

⭐ Support

If you like this project:

⭐ Star it
🍴 Fork it
🤝 Contribute