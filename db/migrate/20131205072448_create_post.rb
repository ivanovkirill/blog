# encoding: utf-8
class CreatePost < ActiveRecord::Migration
  def up
  	create_table :posts do |t|
  		t.belongs_to :user
      t.string :title
  		t.text :body
  		t.timestamps
  	end
  end

  def down
  	drop_table :posts
  end
end