class Book < ApplicationRecord
  belongs_to :user
  has_many :books_categories
  has_many :categories, through: :books_categories

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
end
