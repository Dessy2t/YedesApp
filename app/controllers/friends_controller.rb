class FriendsController < ApplicationController
    include FriendRequestsHelper
    include FriendsHelper
    include UsersHelper

    def new
        @friendship = Friend.new()
    end

    def create
        users = friend_params_full
        @friendship = Friend.new(users.except(:id))
        if @friendship.save
            request = FriendRequest.friendly.find(users[:id]).id
            FriendRequest.destroy(request)
            create_chat(users[:user_id], users[:friend_id])
            create_inverse_friendship(users)
        end
    end

    def destroy
        friendship = Friend.friendly.find(params[:id])
        users = {user_id: friendship.user_id, friend_id: friendship.friend_id}
        if friendship.destroy
            destroy_inverse_friendship(users)
        end
    end

    private

    def friends_params
        params.permit(:id)
    end

    def friend_params_full
        data = friends_params
        data[:user_id] = User.find(FriendRequest.friendly.find(data[:id]).sender).id
        data[:friend_id] = User.find(FriendRequest.friendly.find(data[:id]).receiver).id
        data[:uuid] = SecureRandom.uuid
        data
    end

    def create_inverse_friendship(users)
        @friendship = Friend.create(user_id: users[:friend_id], friend_id: users[:user_id], uuid: SecureRandom.uuid)
    end

    def destroy_inverse_friendship(users)
        Friend.where(user_id: users[:friend_id], friend_id: users[:user_id]).first.destroy
    end
end
