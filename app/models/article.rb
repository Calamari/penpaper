class Article < ActiveRecord::Base
  attr_accessible :html, :published_at, :slug, :text, :title

  validates_presence_of :text, :title

  scope :draft, lambda { where(:published_at => nil) }
  scope :published, lambda { where('published_at IS NOT NULL') }

  before_save :generate_html
  before_save :generate_slug

  def publish
    self.published_at = Time.now
  end

  def unpublish
    self.published_at = nil
  end

  def draft?
    published_at.nil?
  end

  def published?
    !draft?
  end

  def teaser
    text.split('<!--more-->').first
  end

  private

  def generate_html
    self.html = Kramdown::Document.new(text, {
      coderay_line_numbers: :table
    }).to_html
  end

  def generate_slug
    self.slug = title.parameterize
  end
end
