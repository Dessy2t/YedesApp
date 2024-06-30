module FriendsHelper

    def create_chat(user_id, friend_id)
        Chat.create(user_id: user_id, friend_id: friend_id, uuid: SecureRandom.uuid)
    end

    def find_friendship(user_id, friend_id)
        Friend.find_by(user_id: get_id(user_id), friend_id: get_id(friend_id)).slug
    end
end
