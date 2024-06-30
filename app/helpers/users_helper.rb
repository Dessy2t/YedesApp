module UsersHelper
    def is_friend?(user, friend)
        user.friends.map { |friend| friend.friend_id}.include?(friend.id)
    end

    def country_code(name)
        @countries.key(name).upcase
    end

    def get_id(query)
        return nil if query.nil?
        user = User.find_by(username: query)
        if user
            user.id
        else
            user = User.find_by(uuid: query).id
        end
    end
end
