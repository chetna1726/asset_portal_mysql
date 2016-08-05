class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :isbn
      t.string :title
      t.integer :year_published
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
