class Chat < ApplicationRecord
    extend FriendlyId
    has_many :messages, foreign_key: 'chat_id', dependent: :destroy
    belongs_to :user
    belongs_to :friend, class_name: 'User', foreign_key: :friend_id
    validates :user_id, uniqueness: {scope: :friend_id }
    friendly_id :uuid, use: :slugged
end
