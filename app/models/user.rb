require 'bcrypt'

class User < ActiveRecord::Base
  has_many :folios
  has_many :elements, through: :folios

  validates :email, uniqueness: true,
                    presence: true,
                    format: { with: /\w+@\w+\.\w{2,3}/i, message: "please enter a valid email address"},
                    # unless: :provider
                    :if => 'provider.blank?'

  # validates :password, presence: true, unless: :provider
  has_secure_password(validations: false)

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end


end
