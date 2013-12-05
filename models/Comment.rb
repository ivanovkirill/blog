# encoding: utf-8
class Comment < ActiveRecord::Base
   validates :body, presence: true
   has_many :user
end