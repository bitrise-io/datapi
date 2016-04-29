class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  protected

  # Authenticate the user with token based authentication
  def authenticate_by_readonly_api_token
    authenticate_readonly_token || render_unauthorized
  end

  def authenticate_by_read_write_api_token
    authenticate_read_write_token || render_unauthorized
  end

  def authenticate_readonly_token
    authenticate_with_http_token do |token, options|
      token == Rails.application.secrets.datapi_readonly_api_token
    end
  end

  def authenticate_read_write_token
    authenticate_with_http_token do |token, options|
      token == Rails.application.secrets.datapi_read_write_api_token
    end
  end

  def render_unauthorized(realm = "Application")
    render json: {error_message: 'Bad credentials'}, status: :unauthorized
  end
end
