class User < ApplicationRecord
    extend FriendlyId
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :omniauthable, omniauth_providers: [:google_oauth2]
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable, :timeoutable
    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :reactions, dependent: :destroy
    has_many :friends, dependent: :destroy
    has_many :reverse_friends, class_name: 'Friend', foreign_key: 'friend_id', dependent: :destroy
    has_many :friend_requests, foreign_key: :receiver, dependent: :destroy
    has_many :friend_requests_sent, foreign_key: :sender, class_name: 'FriendRequest', dependent: :destroy
    has_one_attached :profile_picture
    has_many :sent_notifications, class_name: 'Notification', foreign_key: 'sender', dependent: :destroy
    has_many :notifications, class_name: 'Notification', foreign_key: 'receiver', dependent: :destroy
    has_one_attached :cover_picture
    friendly_id :username, use: :slugged
    has_many :chats, dependent: :destroy
    has_many :chats_friend, class_name: 'Chat', foreign_key: 'friend_id', dependent: :destroy
    has_many :messages, dependent: :destroy
    has_many :pages
    validates :birthday, comparison: { less_than: Date.today- 10.years, message: ': You must be at least 10 years old'}, if: -> {birthday.present?}
    validates :username, uniqueness: true
  
    def self.from_omniauth(access_token)
      data = access_token.info
      user = User.where(email: data['email']).first
      last_name = data['last_name'].present? ? data['last_name'] : ' '
      unless user
          user = User.create(first_name: data['first_name'],
          last_name: last_name,
          email: data['email'],
          password: Devise.friendly_token[0,20],
          uuid: SecureRandom.uuid,
          username: "#{data[:first_name].downcase}-#{last_name.downcase}-#{Random.rand(1000..9999)}",
          provider: 'Google',
          profile_picture: File.open('app/assets/images/pfp.jpg'),
          cover_picture: File.open('app/assets/images/cover_default.jpg')
          )
      end
      user
    end
  
    def self.destroy
      if self.is_guest
        self.guest_cleanup
        self.destroy
      end
    end
  
    def self.guest_cleanup
      self.profile_picture_attachment.purge
      self.cover_picture_attachment.purge
      self.posts.joins(:image_attachment).each {|post| post.image_attachment.purge}
    end
  
  end
  