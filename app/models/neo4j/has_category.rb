class Neo4j::HasCategory
  include Neo4j::ActiveRel

  from_class :'Neo4j::Book'
  to_class :'Neo4j::Category'
  type 'has_category'

  property :id, type: Integer
end
