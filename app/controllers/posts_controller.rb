class PostsController < ApplicationController
    include FriendRequestsHelper
    include PostsHelper
    before_action :resize, only: [:create]

    def index
        friends = current_user.friends.map {|friend| friend.friend_id}
        @feed = Post.where(user_id: friends).or(Post.where(user_id: current_user)).or(Post.where.not(page_id: nil)).paginate(page: 1, per_page: 10).order(created_at: :desc)
        @people = User.where.not(id: friends).and(User.where.not(id:current_user)).and(User.where(is_guest: nil))
        @people = @people.filter {|person| find_request(current_user, person).nil? }
        unless @people.empty? then @people = @people.take(3) end
        respond_to do |format|
            format.turbo_stream do
                @feed = @feed.page(params[:page])
                render turbo_stream: turbo_stream.append("posts", partial: "posts/post", collection: @feed,
                    locals: {location: 'feed'})
            end
            format.html
        end
    end

    def new
         @post = Post.new
    end

    def welcome
        @user = current_user
    end

    def create
        @post = Post.new(post_params_full)
        unless @post.user == current_user || @post.page.user == current_user
            return render posts_path, status: :unprocessable_entity
        end
        if @post.save
            if @post.shared_post.present?
                poster = @post.shared_post.user
                unless poster == @post.user
                    Notification.create(sender:@post.user, receiver: poster, post_id: @post.shared_post.id, action: 'shared')
                end
            end
            respond_to do |format|
                format.turbo_stream do
                    if @post.shared_post.present?
                    render turbo_stream: [
                        turbo_stream.prepend("posts", partial: "posts/post",
                        locals: { post: @post, location: 'feed', is_page: @post.page_id}),
                        turbo_stream.remove('error-div'),
                        turbo_stream.replace("shares-count-#{@post.shared_post.slug}",
                        partial: 'posts/shares_count', locals: {post: @post.shared_post})]
                    else
                        render turbo_stream: [
                            turbo_stream.prepend("posts", partial: "posts/post",
                            locals: { post: @post, location: 'feed', is_page: @post.page_id}),
                            turbo_stream.remove('error-div'),
                            turbo_stream.replace('text-field', partial:'posts/empty_input')]
                    end
                end
                format.html
            end
        else
            respond_to do |format|
                format.turbo_stream do
                    render turbo_stream: turbo_stream.prepend("feed", partial: 'posts/errors',
                    locals: {errors: @post.errors.full_messages})
                end
            end
        end
    end

    private

    def resize
        if params[:post][:image].present?
            acceptable_formats = ['image/jpg', 'image/png','image/jpeg']
            tempo = resize_before_save(params[:post][:image], 810, 500)
            if acceptable_formats.include?(params[:post][:image].content_type) && tempo != 'bad format'
                  params[:post][:image] = ActionDispatch::Http::UploadedFile.new(
                    tempfile: tempo,
                    filename: tempo.path,
                    type: 'image/jpeg'
                )
            else
                respond_to do |format|
                    format.turbo_stream do
                        render turbo_stream: turbo_stream.prepend("feed", partial: 'posts/errors',
                        locals: {errors: ['File extension has to be jpg or png']})
                    end
                end
            end
        end
    end

    def post_params
        params.require(:post).permit(:body, :image, :shared_post, :uuid, :page_id)
    end

    def post_params_full
        data = post_params
        if data[:page_id].present?
            data[:page_id] = Page.friendly.find(data[:page_id]).id
        else
            data[:user_id] =  current_user.id
        end
        data[:uuid] = SecureRandom.uuid
        unless data[:shared_post].nil?
            data[:shared_post] = Post.friendly.find(data[:shared_post])
        end
        data
    end
end
