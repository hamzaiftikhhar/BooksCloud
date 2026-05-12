class BookSearch
  def self.call(query, genre: nil, availability: nil)
    new(query: query, genre: genre, availability: availability).execute
  end

  def initialize(scope = Book.all, query: nil, genre: nil, availability: nil)
    @scope = scope
    @query = query&.strip
    @genre = genre&.strip
    @availability = availability&.strip
  end

  def execute
    results = @scope
    results = filter_by_query(results) if @query.present?
    results = filter_by_genre(results) if @genre.present?
    results = filter_by_availability(results) if @availability.present?
    results
  end

  private

  def filter_by_query(scope)
    scope.joins(:author)
         .where(
           "books.title ILIKE ? OR books.isbn ILIKE ? OR authors.first_name ILIKE ? OR authors.last_name ILIKE ?",
           "%#{@query}%",
           "%#{@query}%",
           "%#{@query}%",
           "%#{@query}%"
         )
         .distinct
  end

  def filter_by_genre(scope)
    scope.where(genre: @genre)
  end

  def filter_by_availability(scope)
    case @availability
    when "available"
      scope.where("available_copy_count > 0")
    when "unavailable"
      scope.where("available_copy_count = 0")
    else
      scope
    end
  end
end
