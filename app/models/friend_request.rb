class FriendRequest < ApplicationRecord
    extend FriendlyId
    friendly_id :uuid, use: :slugged
end
