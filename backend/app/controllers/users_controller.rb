class UsersController < ApplicationController
    before_action :load_current_user
    
    def me
        authorize @current_user
        render json: { success: true, user: @current_user.as_json } 
    end

    def show
        user = User.find(params[:id])
        authorize user
        render json: { success: true, user: @current_user.as_json } 
    end
end
