# encoding: utf-8
class User < ActiveRecord::Base
  I18n.enforce_available_locales = true
  has_many :posts
  has_many :comments
   
  validates :name, presence: true, length: { minimum: 3 }
  validates :password, length: { minimum: 8 }, confirmation: true
  validates :email,
    presence: true,
    uniqueness: true,
    format: { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create }
end