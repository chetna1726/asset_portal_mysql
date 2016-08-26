class Category < ApplicationRecord
  has_many :books_categories
  has_many :books, through: :books_categories

  validates :name, :isbn, presence: true
  validates :name, uniqueness: true, allow_blank: true

  after_create :populate_graph_db
  after_destroy :remove_from_graph_db

  private

    def populate_graph_db
      Neo4j::Category.create(name: name)
    end

    def remove_from_graph_db
      Neo4j::Category.where(name: name).destroy
    end
end
