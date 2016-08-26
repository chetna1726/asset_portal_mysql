class Book < ApplicationRecord
  belongs_to :user
  has_many :books_categories
  has_many :categories, through: :books_categories

  validates :title, :isbn, presence: true
  validates :title, :isbn, uniqueness: true, allow_blank: true

  after_create :populate_graph_db
  after_destroy :remove_from_graph_db

  def self.recommendations
    recommendations = {}
    Book.all.each do |book|
      if book.categories.count > 1
        category_ids = book.categories.ids
        recommendation_ids = category_ids.map do |category_id|
          current_category_books_ids = Category.find(category_id).books.ids
          other_books_ids = BooksCategory.where(category_id: category_ids - [category_id]).pluck(:book_id)
          current_category_books_ids & other_books_ids
        end.flatten.uniq
        recommendation_ids = recommendation_ids - [book.id]
        recommendation = Book.where(id: recommendation_ids)
      end
      recommendations["#{book.isbn.to_s}"] = recommendation if recommendation
    end
    recommendations
  end

  private

    def populate_graph_db
      book = Neo4j::Book.create(isbn: isbn, title: title, year_published: year_published)
      book.author = Neo4j::User.find_by(name: user.name) if user_id?
    end

    def remove_from_graph_db
      Neo4j::Book.where(isbn: isbn).destroy
    end
end
