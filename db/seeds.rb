# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data
[ User, Book, Author, Member, Borrowing, Fine ].each(&:delete_all)

puts "Seeding database..."

# Create Users
admin_user = User.create!(
  email: 'admin@library.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: 'admin'
)

librarian_user = User.create!(
  email: 'librarian@library.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: 'librarian'
)

puts "Created 2 users (1 admin, 1 librarian)"

# Create Authors
authors = [
  { first_name: "Haruki", last_name: "Murakami" },
  { first_name: "Margaret", last_name: "Atwood" },
  { first_name: "George", last_name: "Orwell" },
  { first_name: "Jane", last_name: "Austen" },
  { first_name: "Paulo", last_name: "Coelho" }
]

author_map = authors.map { |attrs| Author.create!(attrs) }
puts "Created #{author_map.length} authors"

# Create Books
books = [
  {
    author: author_map[0],
    title: "Norwegian Wood",
    isbn: "9780060850524",
    genre: "Fiction",
    description: "A nostalgic novel about love and loss",
    publication_date: Date.new(1987, 9, 4),
    total_copy_count: 5,
    available_copy_count: 5
  },
  {
    author: author_map[1],
    title: "The Handmaid's Tale",
    isbn: "9780385490818",
    genre: "Dystopian Fiction",
    description: "A dystopian novel about a totalitarian regime",
    publication_date: Date.new(1985, 6, 20),
    total_copy_count: 4,
    available_copy_count: 4
  },
  {
    author: author_map[2],
    title: "1984",
    isbn: "9780451524942",
    genre: "Science Fiction",
    description: "A political allegory about totalitarianism",
    publication_date: Date.new(1949, 6, 8),
    total_copy_count: 6,
    available_copy_count: 6
  },
  {
    author: author_map[3],
    title: "Pride and Prejudice",
    isbn: "9780141439518",
    genre: "Romance",
    description: "A classic romance novel about Elizabeth Bennet",
    publication_date: Date.new(1813, 1, 28),
    total_copy_count: 3,
    available_copy_count: 3
  },
  {
    author: author_map[4],
    title: "The Alchemist",
    isbn: "9780061125371",
    genre: "Fiction",
    description: "A philosophical novel about following your dreams",
    publication_date: Date.new(1988, 1, 1),
    total_copy_count: 7,
    available_copy_count: 7
  }
]

book_map = books.map { |attrs| Book.create!(attrs) }
puts "Created #{book_map.length} books"

# Create Members
members = [
  {
    name: "Ahmed Ali",
    email: "ahmed@example.com",
    phone: "03001234567",
    status: "active",
    max_books_allowed: 3
  },
  {
    name: "Fatima Khan",
    email: "fatima@example.com",
    phone: "03009876543",
    status: "active",
    max_books_allowed: 3
  },
  {
    name: "Hassan Mohammed",
    email: "hassan@example.com",
    phone: "03005555555",
    status: "suspended",
    max_books_allowed: 3
  },
  {
    name: "Ayesha Malik",
    email: "ayesha@example.com",
    phone: "03003333333",
    status: "active",
    max_books_allowed: 2
  }
]

member_map = members.map { |attrs| Member.create!(attrs) }
puts "Created #{member_map.length} members"

# Create sample borrowings
borrowing1 = Borrowing.create!(
  member: member_map[0],
  book: book_map[0],
  status: "active",
  due_date: Date.current + 14.days
)

# Overdue borrowing
overdue_borrowing = Borrowing.create!(
  member: member_map[1],
  book: book_map[1],
  status: "active",
  due_date: Date.current - 5.days
)

# Create fine for overdue borrowing
Fine.create!(
  borrowing: overdue_borrowing,
  amount_due: 50,
  status: "outstanding"
)

puts "Created 2 borrowings and 1 fine"

puts "\n✓ Database seeding completed!"
puts "\nDemo Credentials:"
puts "Admin Email: admin@library.com"
puts "Admin Password: password123"
puts "\nLibrarian Email: librarian@library.com"
puts "Librarian Password: password123"
