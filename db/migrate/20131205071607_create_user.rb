# encoding: utf-8
class CreateUser < ActiveRecord::Migration
  def up
  	create_table :users do |n|
  		n.string :email
  		n.string :password
  		n.string :name
  	end
  end

  def down
  	drop_table :users
  end
end