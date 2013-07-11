class AddIndexesToArticles < ActiveRecord::Migration
  def change
    add_index :articles, :published_at
    add_index :articles, :slug
  end
end
