class RootController < ApplicationController

  def index
    welcome_msg = "Welcome to DatAPI!"
    render json: { 'message' => welcome_msg }
  end

end
