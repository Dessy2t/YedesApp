class MessagesController < ApplicationController
    include ChatsHelper
    include UsersHelper
    include MessagesHelper

    def index
        @friends = current_user.friends.map {|friend| friend.friend }.uniq
        @chats = Chat.where(user_id: current_user.id).or(Chat.where(friend_id: current_user.id))
    end

    def new
        @message = Message.new
    end

    def create
        data = message_params_full
        id = data[:chat_id]
        chat = Chat.find(id)
        check_date = chat.messages.filter {|mes| mes.created_at.strftime("%D") == DateTime.now.strftime('%D')}
        if check_date.length == 0
            @message = Message.create(user_id: current_user.id, chat_id: id, body: DateTime.now.strftime('%D'), is_date: true, seen: true)
            ActionCable.server.broadcast("ChatsChannel", {message: @message.body, is_date: true, chat_id: @message.chat.slug})
        end
        @message = Message.create(data)
            ActionCable.server.broadcast("ChatsChannel", {
                message: @message.body,
                chat_id: @message.chat.slug,
                current_user: current_user.slug,
                date: @message.created_at.strftime("%R")})
    end

    def show
        friendship = Friend.find(params[:id])
        if friendship.user == current_user
            @friend = friendship.friend
        else
            @friend = friendship.user
        end
        @messages = Message.where(chat_id: params[:id]).order('created_at ASC')
    end

    def update
        data = update_params_full
        messages = get_unseen(data[:chat_id], current_user.id)
        unless messages.nil?
            messages.each {|mes| mes.update(seen: true)}
        end
    end

    private

    def message_params
        params.require(:message).permit(:chat_id, :body, :seen)
    end

    def message_params_full
        data = message_params
        data[:user_id] = current_user.id
        data[:chat_id] = Chat.friendly.find(data[:chat_id]).id
        data
    end

    def update_params
        params.permit(:chat_id)
    end

    def update_params_full
      data = update_params
      data[:chat_id] = Chat.friendly.find(data[:chat_id]).id
      data
    end

end
