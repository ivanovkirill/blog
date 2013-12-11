# encoding: utf-8
class CreateComments < ActiveRecord::Migration
  def up
  	create_table :comments do |t|
  		t.belongs_to :user
  		t.belongs_to :post
  		t.string :body
  		t.timestamps
     end
  end

  def down
  	drop_table :comments
  end
end
