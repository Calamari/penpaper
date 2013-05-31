class User < ActiveRecord::Base
  attr_accessible :email, :name, :password

  validates_presence_of :email, :name
  validates_presence_of :password, :on => :create

  has_secure_password
end
