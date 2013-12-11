# encoding: utf-8
class CreateUser < ActiveRecord::Migration
  def up
  	create_table :users do |t|
  		t.string :email
  		t.string :password
  		t.string :name
      t.timestamps
  	end
  end

  def down
  	drop_table :users
  end
end