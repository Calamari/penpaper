class Article < ActiveRecord::Base
  attr_accessible :html, :published_at, :slug, :text, :title

  validates_presence_of :html, :slug, :text, :title

  scope :draft, lambda { where(:published_at => nil) }
  scope :published, lambda { where('published_at IS NOT NULL') }

  def draft?
    published_at.nil?
  end

  def published?
    !draft?
  end
end
