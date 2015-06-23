class AddSpotifyUidToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :spotify_uid, :string
  end
end
