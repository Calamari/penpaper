class AddTeaserToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :teaser_html, :text
  end
end
