class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    def index
        render :template => 'layouts/index'
    end
end
