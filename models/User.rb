# encoding: utf-8
class User < ActiveRecord::Base
  validates :email, presence: true
  validates :password, presence: true
  validates :name, presence: true
  has_many :post
end
