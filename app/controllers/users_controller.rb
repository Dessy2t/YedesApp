class UsersController < ApplicationController
    include UsersHelper
    include FriendRequestsHelper
    include PostsHelper
    include FriendsHelper

    before_action :resize, only: [:update]
    skip_before_action :authenticate_user!, only: [:create]

    def index
        @users = User.all.where(is_guest: nil)
    end

    def new
        @user = User.new
    end

    def create
        if params[:is_guest]
            data = guest_params
            @user = User.new(data)
        else
            @user = User.new(user_params)
        end
        if @user.save
            sign_in @user
            redirect_to welcome_path
            if @user.is_guest
                @user.delay(run_at: 6.hours.from_now).destroy
            end
        else
            p @user.errors.full_messages
        end
    end

    def show
        @countries = JSON.load(File.open('countries'))
        @min_date = Date.today- 10.years
        @user = User.friendly.find(params[:username])
        @friends = @user.friends.map {|friend| friend.friend_id}
        @photos = @user.posts.joins(:image_attachment).order('created_at DESC').take(6)
        @friendship = friendship_status(@user, current_user)
        @posts = @user.posts.paginate(page: 1, per_page: 10).order(created_at: :desc)
        respond_to do |format|
            format.turbo_stream do
                @posts = @posts.page(params[:page])
                render turbo_stream: turbo_stream.append("posts", partial: "posts/post", collection: @posts,
                    locals: {location: 'feed'})
            end
            format.html
        end
    end

    def update
        @user = User.friendly.find(params[:id])
        if @user == current_user
            if update_params[:profile_picture].present?
                @user.profile_picture_attachment.purge
            end
            if update_params[:cover_picture].present?
                @user.cover_picture_attachment.purge
            end
            if @user.update(update_params)
                redirect_to user_path(@user)
            else
                flash[:errors] = @user.errors.full_messages
                redirect_to @user
            end
        end
    end

    def current
        if current_user
            render json: {user: current_user.slug}
        else
            redirect_to posts_path, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.permit(first_name, last_name, email, encrypted_password, bio, location, profile_picture, cover_picture, uuid, username)
    end

    def update_params
        params.require(:user).permit(:cover_picture, :profile_picture, :bio, :location, :current_password, :birthday)
    end

    def guest_params
        user = {first_name: 'Guest', last_name: Random.rand(111..999), email: "#{SecureRandom.hex(6)}@#{SecureRandom.hex(6)}.com",
        encrypted_password: 123456, password: 123456, uuid: SecureRandom.uuid, profile_picture: File.open('app/assets/images/pfp.jpg'),
        cover_picture: File.open('app/assets/images/cover_default.jpg'), is_guest: true}
        user[:username] = "#{user[:first_name].downcase}-#{user[:last_name]}-#{Random.rand(1000..9999)}"
        user
    end

    def resize
        if params[:user][:profile_picture].present?
            acceptable_formats = ['image/jpg', 'image/png','image/jpeg']
            tempo = resize_before_save(params[:user][:profile_picture], 120, 120)
            if acceptable_formats.include?(params[:user][:profile_picture].content_type) && tempo != 'bad format'
            params[:user][:profile_picture] = ActionDispatch::Http::UploadedFile.new(
                tempfile: tempo,
                filename: tempo.path,
                type: 'image/jpeg'
            )
            else
                flash[:errors] = ['File extension has to be jpg or png']
                redirect_to current_user
            end
        end
        if params[:user][:cover_picture].present?
            acceptable_formats = ['image/jpg', 'image/png','image/jpeg']
            tempo = resize_before_save(params[:user][:cover_picture], 1100, nil)
            if acceptable_formats.include?(params[:user][:cover_picture].content_type) && tempo != 'bad format'
            params[:user][:cover_picture] = ActionDispatch::Http::UploadedFile.new(
                tempfile: tempo,
                filename: tempo.path,
                type: 'image/jpeg'
            )
            else
                flash[:errors] = ['File extension has to be jpg or png']
                redirect_to current_user
            end
        end
    end

end
