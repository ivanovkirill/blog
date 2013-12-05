# encoding: utf-8
class CreateComments < ActiveRecord::Migration
  def up
  	create_table :comments do |m|
  		m.text :body
  	end
  end

  def down
  	drop_table :comments
  end
end
