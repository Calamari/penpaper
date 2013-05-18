class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :text
      t.text :html
      t.datetime :published_at
      t.string :slug

      t.timestamps
    end
  end
end
