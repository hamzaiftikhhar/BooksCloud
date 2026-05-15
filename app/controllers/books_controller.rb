class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = Book.all.page(params[:page]).per(10) # Show all books with pagination /books?page=2

    if params[:q].present? || params[:genre].present? || params[:availability].present? # conditional search
      @books = BookSearch.new( # create new service object
        Book.includes(:author),
        query: params[:q],
        genre: params[:genre],
        availability: params[:availability]
      ).execute.page(params[:page]).per(10)
    end
    respond_to do |format|
    format.html
    format.json { render json: @books }# for RSpecs so it can get the json rather than the HTML response
  end
  end

  def search
    index
    render :index
  end

  def show
    @members = Member.active.order(:name) # why scope :active, ->{status: active}
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)

    handle_author_creation(@book)

    if @book.save
      redirect_to @book, notice: "Book created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    handle_author_creation(@book)

    if @book.update(book_params)
      redirect_to @book, notice: "Book updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

def search_authors
  query = params[:q].to_s.strip.downcase

  return render json: [] if query.blank?

  authors = Author.where(
    "LOWER(first_name) LIKE :q OR LOWER(last_name) LIKE :q OR LOWER(first_name || ' ' || last_name) LIKE :q",
    q: "%#{query}%"
  ).limit(10)

  render json: authors.map { |a|
    {
      id: a.id,
      name: a.name,
      first_name: a.first_name,
      last_name: a.last_name
    }
  }
end

  def destroy
    if current_user.admin?
      @book.destroy
      redirect_to books_path, notice: "Book deleted successfully."
    else
      redirect_to @book, alert: "Only admins can delete books."
    end
  end

  def handle_author_creation(book)
    return if params[:book][:author_id].present?
    return if params[:book][:author_name].blank?

    author_name = params[:book][:author_name].strip
    first_name, last_name = author_name.split(" ", 2)
    last_name ||= first_name

    author = Author.find_or_create_by(
      first_name: first_name,
      last_name: last_name
    )

    book.author_id = author.id
  end

  private

  def set_book
    @book = Book.find_by(id: params[:id])
    redirect_to books_path, alert: "Book not found." unless @book
  end

  def book_params
    params.require(:book).permit(
      :title,
      :author_id,
      :author_name,
      :isbn,
      :genre,
      :description,
      :publication_date,
      :total_copy_count,
      :available_copy_count,
      :cover,
    ).except(:author_name)
  end
end
