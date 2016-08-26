class Neo4j::User
  include Neo4j::ActiveNode
  property :name, type: String
  property :email, type: String

  validates_presence_of :name, :email
  validates_uniqueness_of :name, scope: :email, allow_blank: true

end
