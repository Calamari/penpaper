class Article < ActiveRecord::Base
  attr_accessible :html, :published_at, :slug, :text, :title

  validates_presence_of :slug, :text, :title

  scope :draft, lambda { where(:published_at => nil) }
  scope :published, lambda { where('published_at IS NOT NULL') }

  before_save :generate_html

  def draft?
    published_at.nil?
  end

  def published?
    !draft?
  end

  private

  def generate_html
    self.html = Kramdown::Document.new(text).to_html
  end
end
