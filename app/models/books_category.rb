class BooksCategory < ApplicationRecord
  belongs_to :book
  belongs_to :category

  validates :book, :category, presence: true
  validates :book, uniqueness: { scope: :category }, allow_blank: true

  after_create :populate_graph_db
  after_destroy :remove_from_graph_db

  private

    def populate_graph_db
      book1 = Neo4j::Book.find_by(isbn: book.isbn)
      category1 = Neo4j::Category.find_by(name: category.name)
      Neo4j::HasCategory.create(from_node: book1, to_node: category1, id: id)
    end

    def remove_from_graph_db
      Neo4j::HasCategory.where(id: id).destroy
    end
end
