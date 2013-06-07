class Tag < ActiveRecord::Base
  attr_accessible :name

  has_and_belongs_to_many :articles, :uniq => true

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.find_or_create(name)
    tag = Tag.where(name: name).first
    tag = Tag.new(name: name) unless tag.present?
    tag
  end
end
