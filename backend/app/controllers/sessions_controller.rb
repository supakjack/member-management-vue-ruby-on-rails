class SessionsController < ApplicationController
    before_action :load_current_user, only: [:sign_out]

    def sign_up
        user = User.new(sign_up_params)
        if user.save
            render json: { success: true, user: user.as_json }, status: :created
        else
            render json: { success: false, errors: user.errors.as_json }, status: :bad_request
        end
    end

    def sign_in
        user = User.find_by_email(params[:email])
        if user.confirmed? && user.valid_password?(params[:password])
            render json: { success: true, jwt: user.jwt(1.days.from_now) }, status: :created
        else
            render json: { success: false }, status: :unauthorized
        end
    end

    def sign_out
       @current_user.generate_auth_token(true) 
       @current_user.save
       render json: { success: true } 
    end

    def confirm
        user = User.find_by_confirmation_token(params[:confirmation_token]) # get confirmation_token from user.confirmation_token
        render json: { success: !!user&.confirm  }
    end

    private
    def sign_up_params
        params.permit(:email, :password,:password_confirmation, :first_name, :last_name)
    end
end
