class ChatsController < ApplicationController

    def index
        @friends = current_user.friends.map {|friend| friend.friend }.uniq
        @chats = Chat.where(user_id: current_user.id).or(Chat.where(friend_id: current_user.id))
    end

    def new
        @chat = Chat.new
    end

    def create
        @chat = Chat.create(chat_params)
    end

    def show
        @chat = Chat.friendly.find(params[:id])
        @messages = Message.where(chat_id: @chat.id).order('created_at ASC')
        respond_to do |format|
            format.turbo_stream do
                render turbo_stream: turbo_stream.replace("chat", partial: "chats/template",
                locals: { chat: @chat, messages: @messages })
            end
            format.html {render partial: 'chats/template', locals: { chat: @chat, messages: @messages }}
        end
    end

    private
    
    def chat_params
        params.permit(:user_id, :friend_id, :uuid)
    end
end
