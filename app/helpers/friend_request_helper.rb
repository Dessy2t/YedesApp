module FriendRequestsHelper
    include UsersHelper

    def request_id(id)
        FriendRequest.friendly.find(id).id
    end

    def find_request(user_id, friend_id)
        @request = FriendRequest.where(sender: user_id, receiver: friend_id).first
        if @request.nil?
            FriendRequest.where(sender: friend_id, receiver: user_id).first
        else
            @request
        end
    end

    def friendship_status(user, friend)
        if is_friend?(user, friend)
            @friendship = 'friends'
        else
            @friendship = 'noFriends'
            friend_request = find_request(user, friend)
            unless friend_request.nil?
                if friend_request.sender == friend.id.to_s
                    @friendship = 'Request Sent'
                else
                    @friendship = 'Request Received'
                end
            end
        end
        @friendship
    end
end