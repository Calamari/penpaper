class CreateArticleToTagsJoinTable < ActiveRecord::Migration
  def up
    create_table :articles_tags, :id => false do |t|
      t.integer :article_id
      t.integer :tag_id
    end
    add_index :articles_tags, [:article_id, :tag_id]
  end

  def down
    drop_table :articles_tags
  end
end
