class CommentsController < ApplicationController
    include UsersHelper
    include PostsHelper

    def new
        @comment = Comment.new
    end

    def create
        @comment = Comment.new(comment_params_full)
        if @comment.user == current_user
            respond_to do |format|
                if @comment.save
                    poster = @comment.post.user
                    unless poster == @comment.user
                        Notification.create(sender:@comment.user, receiver: poster, post_id: @comment.post.id, action: 'commented')
                    end
                    format.turbo_stream do
                        render turbo_stream: [turbo_stream.append("comments_#{@comment.post.slug}",
                                            partial: "comments/comment", locals: { comment: @comment }),
                                            turbo_stream.replace("comment-count-#{@comment.post.slug}",
                                            partial: 'comments/count', locals: {comment: @comment}),
                                            turbo_stream.replace("comment_body_#{@comment.post.slug}",
                                            partial:'comments/empty_comment', locals: {post: @comment.post.slug})]
                    end
                else
                    format.turbo_stream do
                    end
                end
            end
        end
    end

    private

    def comment_params
        params.require(:comment).permit(:post_id, :body)
    end

    def comment_params_full
        data = comment_params
        data[:post_id] = Post.friendly.find(data[:post_id]).id
        data[:user_id] = current_user.id
        data
    end
end
