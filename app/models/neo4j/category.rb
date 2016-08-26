class Neo4j::Category
  include Neo4j::ActiveNode
  property :name, type: String

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :in, :books, rel_class: :'Neo4j::HasCategory'

end
