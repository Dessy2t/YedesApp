class FriendRequestsController < ApplicationController
    include UsersHelper
    include FriendRequestsHelper

    def index
        user = User.find(current_user.id)
        @requests = user.friend_requests.order('created_at DESC')
    end

    def new
        @friend_request = FriendRequest.new
    end

    def create
        data = friend_request_params_full
        if data[:sender] == current_user.id
            @friend_request = FriendRequest.create(data)
            head :ok
        end
    end

    def update
        @friend_request = FriendRequest.friendly.find(params[:id])
        if current_user.id == @friend_request.receiver.to_i
            @friend_request.update(ignored: true)
        end
    end

    def destroy
        friend_request = FriendRequest.find(params[:id])
        friend_request.destroy
    end

    private

    def friend_request_params
        params.permit(:receiver)
    end

    def friend_request_params_full
        data = friend_request_params
        data[:sender] =  current_user.id
        data[:receiver] = User.friendly.find(data[:receiver]).id
        data[:uuid] =  SecureRandom.uuid
        data
    end

    def update_params
        params.require(:friend_request).permit(:ignored)
    end
end
