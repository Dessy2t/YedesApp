class Post < ApplicationRecord
    extend FriendlyId
    belongs_to :user, optional: true
    has_many :comments, dependent: :destroy
    has_many :reactions, dependent: :destroy
    has_one_attached :image, dependent: :destroy
    has_many :shares, class_name: 'Post', foreign_key: 'shared_post', dependent: :destroy
    has_many :notifications, dependent: :destroy
    friendly_id :uuid, use: :slugged
    belongs_to :page, optional: true
    belongs_to :shared_post, class_name: 'Post', foreign_key: 'shared_post', optional: true
    validates :body, presence: {message: "Can't be blank"}
end
