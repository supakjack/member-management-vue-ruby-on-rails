class ApplicationController < ActionController::API
    include Pundit::Authorization
    before_action :load_current_user, if: @current_user.blank?, only: [:pundit_user]
    rescue_from STBAuthenticationError, with: :rescue_unauthorized
    rescue_from JWT::DecodeError, with: :rescue_unauthorized
    rescue_from JWT::ExpiredSignature, with: :rescue_unauthorized
    rescue_from JWT::ImmatureSignature, with: :rescue_unauthorized
    rescue_from JWT::InvalidIssuerError, with: :rescue_unauthorized
    rescue_from JWT::InvalidIatError, with: :rescue_unauthorized
    rescue_from JWT::VerificationError, with: :rescue_unauthorized
    rescue_from Pundit::NotAuthorizedError, with: :rescue_unauthorized
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found

    def load_current_user
        auht_header =  request.headers["Authorization"]
        raise STBAuthenticationError.new("no token") if auht_header.blank?
        bearer = auht_header.split.first
        raise STBAuthenticationError.new("bad format") if bearer != "Bearer"
        jwt = auht_header.split.last
        raise STBAuthenticationError.new("bad format") if jwt.blank?
        key = Rails.application.credentials.secret_key_base
        decoded = JWT.decode(jwt, key, 'HS256')
        payload = decoded.first
        if payload.blank? || payload["auth_token"].blank?
            raise STBAuthenticationError.new("bad token")
        end
        @current_user = User.find_by_auth_token(payload["auth_token"])
        raise STBAuthenticationError.new("bad token") if @current_user.blank? 
    end

    def pundit_user
        @current_user
    end

    private
    def rescue_unauthorized(error)
        render json:{ success: false, type: error.class.to_s, error: error.to_s }, status: :unauthorized
    end

    def rescue_not_found(error)
        render json:{ success: false, type: error.class.to_s, error: error.to_s }, status: :not_found
    end
end
