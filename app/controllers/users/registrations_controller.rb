# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]
    before_action :set_defaults, only: [:create]
  
    # GET /resource/sign_up
    # def new
    #   super
    # end
  
    # POST /resource
    def create
      super
      flash.discard(:notice)
    end
  
    # GET /resource/edit
    # def edit
    #   super
    # end
  
    # PUT /resource
    # def update
    #   super
    # end
  
    # DELETE /resource
    # def destroy
    #   super
    # end
  
    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end
  
    # protected
  
    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :birthday, :email, :password, :password_confirmation, :cover_picture, :profile_picture, :uuid, :username])
    end
  
    #If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:cover_picture, :profile_picture, :current_password])
    end
  
    def create_username(params)
      username = "#{params[:user][:first_name].downcase}-#{params[:user][:last_name].downcase}-#{Random.rand(1000..9999)}"
      if User.all.any? {|u| u.username == username}
        create_username(params)
      else
        username
      end
    end
  
    def set_defaults
      params[:user][:profile_picture] = File.open('app/assets/images/pfp.jpg')
      params[:user][:cover_picture] =  File.open('app/assets/images/cover_default.jpg')
      params[:user][:uuid] = SecureRandom.uuid
      params[:user][:username] =  create_username(params)
    end
  
    # The path used after sign up.
    def after_sign_up_path_for(resource)
      welcome_path
    end
  
    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
end
  