class Article < ActiveRecord::Base
  attr_accessible :html, :published_at, :slug, :text, :title

  validates_presence_of :html, :slug, :text, :title

  def draft?
    published_at.nil?
  end

  def published?
    !draft?
  end
end
