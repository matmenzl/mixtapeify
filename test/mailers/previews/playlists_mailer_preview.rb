# Preview all emails at http://localhost:3000/rails/mailers/playlists_mailer
class PlaylistsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/playlists_mailer/share
  def share
    PlaylistsMailer.share
  end

end
