class AddSpotifyUserToUsers < ActiveRecord::Migration
  def up
    add_column :users, :spotify_user, :text
  end

  def down
    remove_column :users, :spotify_user
  end
end
