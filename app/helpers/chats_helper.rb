module ChatsHelper

    def find_chat(hash, user)
        Chat.find(hash.where(user_id: user.id).or(hash.where(friend_id: user.id)))
    end

    def chat_id(chat)
        Chat.friendly.find(chat).id
    end

    def get_chats(user)
        user.chats+user.chats_friend
    end

end
