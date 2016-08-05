(1..10).each do |i|
  Category.create(name: "category-#{i}")
end

(1..10).each do |i|
  User.create(name: "author-#{i}")
end

(1..1000).each do |i|
  book = Book.create(isbn: "book-#{i}", title: "title-#{i}", year_published: 2000)
  book.categories = Category.where(id: (2..11).to_a.sample((1..7).to_a.sample))
  book.update(user_id: (2..11).to_a.sample)
end
