class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  attr_accessible :html, :published_at, :slug, :text, :title, :user_id, :image

  has_and_belongs_to_many :tags, :uniq => true

  validates_presence_of :text, :title, :user_id

  has_attached_file :image,
    styles: { full: '900x900>' },
    path: ":rails_root/public/system/:attachment/:id/:style/:hash.:extension",
    url: "/system/:attachment/:id/:style/:hash.:extension",
    hash_secret: "penpaper-hashing-thing"

  scope :draft, lambda { where(:published_at => nil) }
  scope :published, lambda { where('published_at IS NOT NULL') }

  before_save :generate_html
  before_save :generate_teaser_html

  def author
    @author ||= User.find(user_id)
  end

  def publish
    self.published_at ||= Time.now
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

  def open_graph
    open_graph = OpenGraph.new type: 'article', title: title, url: Rails.application.routes.url_helpers.article_url(self)
    open_graph.add('article:author:first_name', 'Georg')
    open_graph.add('article:author:last_name', 'Tavonius')
    open_graph.add('article:tag', tags.map(&:name))
    open_graph.add('article:published_time', published_at.iso8601)
    open_graph.add('image', image) if image.present?
    open_graph
  end

  def twitter_card
    twitter_card = TwitterCard.new card: 'summary', creator: '@Georg_Tavonius', title: title
    twitter_card.add('image', image) if image.present?
    twitter_card
  end

  private

  def parse_markdown(text)
    Kramdown::Document.new(text, {
      coderay_line_numbers: :table,
      coderay_wrap: nil
    }).to_html
  end

  def generate_html
    self.html = parse_markdown(text)
  end

  def generate_teaser_html
    self.teaser_html = parse_markdown(teaser)
  end


  def should_generate_new_friendly_id?
    new_record?
  end
end
