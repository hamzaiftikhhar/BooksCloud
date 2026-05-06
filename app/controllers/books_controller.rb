class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = Book.all.page(params[:page]).per(10)

    if params[:q].present? || params[:genre].present? || params[:availability].present?
      @books = BookSearch.new(
        Book.includes(:author),
        query: params[:q],
        genre: params[:genre],
        availability: params[:availability]
      ).execute.page(params[:page]).per(10)
    end
  end

  def search
    index
    render :index
  end

  def show
    @members = Member.active.order(:name)
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, notice: "Book created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: "Book updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.admin?
      @book.destroy
      redirect_to books_path, notice: "Book deleted successfully."
    else
      redirect_to @book, alert: "Only admins can delete books."
    end
  end

  private

  def set_book
    @book = Book.find_by(id: params[:id])
  end

  def book_params
    params.require(:book).permit(
      :title,
      :author_id,
      :isbn,
      :genre,
      :description,
      :publication_date,
      :total_copy_count,
      :available_copy_count,
      :cover
    )
  end
end
