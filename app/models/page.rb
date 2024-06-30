class Page < ApplicationRecord
    extend FriendlyId
    belongs_to :user
    has_many :posts, class_name: 'Post', foreign_key: 'page_id', dependent: :destroy
    has_one_attached :profile_picture
    has_one_attached :cover_picture
    friendly_id :uuid, use: :slugged
end
