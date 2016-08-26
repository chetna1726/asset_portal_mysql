class Neo4j::Book

  include Neo4j::ActiveNode
  property :title, type: String
  property :isbn, type: String
  property :year_published, type: Integer

  validates_presence_of :title, :isbn
  validates_uniqueness_of :title, scope: :isbn, allow_blank: true

  has_one :in, :author, type: :CREATED, model_class: :'Neo4j::User'
  has_many :out, :categories, model_class: :'Neo4j::Category', rel_class: :'Neo4j::HasCategory'

  def self.recommendations
    recommendations = all(:book).
                      categories(:category).
                      books(:other_book).
                      where('book <> other_book').
                      query.
                      with('book, other_book, count(category) AS count').
                      where('count > 1').
                      pluck('book.isbn', 'collect(other_book)')

    Hash[*recommendations.flatten(1)]
  end
end
