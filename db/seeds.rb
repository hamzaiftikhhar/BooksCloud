# Clear existing data (safe reset for dev)
[ User, Book, Author, Member, Borrowing, Fine ].each(&:delete_all)

puts "Seeding database..."

# ================= USERS =================
User.create!(
  email: 'admin@library.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: 0
)

User.create!(
  email: 'librarian@library.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: 1
)

puts "Users created"

# ================= AUTHORS =================
authors_data = [
  [ "Alix", "E. Harrow" ],
  [ "Carissa", "Broadbent" ],
  [ "Charlaine", "Harris" ],
  [ "Christopher", "Paolini" ],
  [ "Leigh", "Bardugo" ],
  [ "Mark", "Lawrence" ],
  [ "Marlon", "James" ],
  [ "Neil", "Gaiman" ],
  [ "R.F.", "Kuang" ],
  [ "Rebecca", "Yarros" ],
  [ "Samantha", "Shannon" ],
  [ "Shannon", "Chakraborty" ],
  [ "Stephen", "King" ],
  [ "Terry", "Pratchett" ],
  [ "J.R.R.", "Tolkien" ],
  [ "T.H.", "White" ]
]

authors = authors_data.map do |first, last|
  Author.create!(first_name: first, last_name: last)
end

author_hash = authors.index_by { |a| "#{a.first_name} #{a.last_name}" }

puts "Authors created"

# ================= BOOKS =================
books_data = [
  [ "Alix E. Harrow", "The Once and Future Witches", "9780316421999", :fantasy ],
  [ "Carissa Broadbent", "The Serpent and the Wings of Night", "9781957779004", :fantasy ],
  [ "Charlaine Harris", "Dead Until Dark", "9780441008537", :fantasy ],
  [ "Christopher Paolini", "Eragon", "9780375826696", :fantasy ],
  [ "Leigh Bardugo", "Ninth House", "9781250313072", :fantasy ],
  [ "Mark Lawrence", "The Book That Wouldn't Burn", "9780593437919", :fantasy ],
  [ "Marlon James", "Black Leopard, Red Wolf", "9780735220173", :fantasy ],
  [ "Neil Gaiman", "American Gods", "9780062572233", :fantasy ],
  [ "R.F. Kuang", "The Burning God", "9780062662637", :fantasy ],
  [ "Rebecca Yarros", "Fourth Wing", "9781649374042", :fantasy ],
  [ "Samantha Shannon", "The Priory of the Orange Tree", "9781635570281", :fantasy ],
  [ "Shannon Chakraborty", "The Adventures of Amina al-Sirafi", "9780062963499", :fantasy ],
  [ "Stephen King", "The Gunslinger", "9781501143511", :fantasy ],
  [ "Terry Pratchett", "Night Watch", "9780061020643", :fantasy ],
  [ "J.R.R. Tolkien", "The Hobbit", "9780547928227", :fantasy ],
  [ "T.H. White", "The Once and Future King", "9780441627400", :fantasy ]
]

books_data.each do |author_name, title, isbn, genre|
  total = rand(3..10)
  available = rand(0..total)   # ✅ ALWAYS SAFE

  Book.create!(
    author: author_hash[author_name],
    title: title,
    isbn: isbn,
    genre: Book.genres[genre],
    description: "#{title} is a compelling fantasy novel filled with adventure, magic, and deep storytelling.",
    publication_date: Date.new(rand(1950..2023), rand(1..12), rand(1..28)),
    total_copy_count: total,
    available_copy_count: available
  )
end

puts "Books created"

# ================= MEMBERS =================
Member.create!([
  { name: "Ahmed Ali", email: "ahmed@example.com", phone: "03001234567", status: 0, max_books_allowed: 3 },
  { name: "Fatima Khan", email: "fatima@example.com", phone: "03009876543", status: 0, max_books_allowed: 3 },
  { name: "Hassan Ahmed", email: "hassan@example.com", phone: "03005555555", status: 1, max_books_allowed: 2 }
])

puts "Members created"

# ================= BORROWINGS =================
book = Book.first
member = Member.first

Borrowing.create!(
  book: book,
  member: member,
  status: 0,
  issue_date: Date.today,
  due_date: Date.today + 14.days
)

puts "Borrowing created"

puts "\n✅ Seeding complete!"
