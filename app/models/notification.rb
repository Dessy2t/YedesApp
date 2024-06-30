class Notification < ApplicationRecord
    belongs_to :receiver, class_name: 'User', foreign_key: 'receiver'
    belongs_to :sender, class_name: 'User', foreign_key: 'sender'
    belongs_to :post, optional: true
end
