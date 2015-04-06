class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uid, :string
    add_column :users, :name, :string
    add_column :users, :image, :string
    add_column :users, :href, :string
  end
end
