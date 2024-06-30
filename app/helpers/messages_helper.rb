module MessagesHelper

    def date(message)
        message.created_at.strftime('%D, %R')
    end

    def get_unseen(chat, user)
        Chat.find(chat).messages.where(seen: nil).where.not(user_id: user)
    end

    def get_unseen_total(chats, user)
        count = 0
        chats.each {|chat| count += Chat.find(chat.id).messages.where(seen: nil).where.not(user_id: user).count}
        count
    end
end
