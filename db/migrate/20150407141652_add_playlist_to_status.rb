class AddPlaylistToStatus < ActiveRecord::Migration
  def change
    add_column :statuses, :playlist, :string
  end
end
