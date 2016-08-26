class User < ApplicationRecord
  has_many :books

  validates :name, presence: true
  validates :email, uniqueness: { scope: :name }, allow_blank: true

  after_create :populate_graph_db
  after_destroy :remove_from_graph_db

  private

    def populate_graph_db
      Neo4j::User.create(name: name, email: email)
    end

    def remove_from_graph_db
      Neo4j::User.where(email: email).destroy
    end
end
