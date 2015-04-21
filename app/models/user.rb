class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable,
     :omniauthable, :omniauth_providers => [:spotify]

  has_many :statuses, dependent: :destroy
  serialize :spotify_user, Hash
  acts_as_voter

  def self.from_omniauth(auth)
    where(uid: auth.info.id).first_or_create do |user|
      user.uid = auth.info.id
      user.href = auth.info.href
      user.email = auth.info.email.blank? ? "#{auth.info.id}@spotify.com" : auth.info.email
      user.image = auth.info.images[0].url
      user.name = auth.info.display_name
      user.password = Devise.friendly_token[0,20]
    end
  end

  def follows_playlist? playlist_id
    spotihunt_user = RSpotify::User.new(spotify_user)
    spotihunt_user.playlists.map{|p| p.id}.include? playlist_id
  end
end
