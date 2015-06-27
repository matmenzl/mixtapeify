class PlaylistsMailer < ActionMailer::Base
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.playlists_mailer.share.subject
  #
  def share sender, recipient, status_id
    @status = Status.find(status_id)
    @sender = sender
    mail(to: recipient, subject: "#{@sender.name} shared a playlist with you from spotihunt.com!", from: @sender.email)
  end
end
