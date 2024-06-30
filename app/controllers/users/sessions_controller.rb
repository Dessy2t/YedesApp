# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]
  
    # GET /resource/sign_in
    # def new
    #   super
    # end
  
    # POST /resource/sign_in
    def create
      super
      flash.discard(:notice)
    end
  
    # DELETE /resource/sign_out
    def destroy
      if current_user.is_guest
        guest_cleanup(current_user)
        current_user.destroy
        return redirect_to root_path
      end
      super
      flash.discard(:notice)
    end
  
    protected
  
    def after_sign_in_path_for(resource)
      posts_path
    end
  
    def guest_cleanup(user)
      user.profile_picture_attachment.purge
      user.cover_picture_attachment.purge
      user.posts.joins(:image_attachment).each {|post| post.image_attachment.purge}
    end
  
    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
end
  