class RootController < ApplicationController

  def index
    welcome_msg = "Welcome to DatAPI! You can read more about the project at: https://github.com/bitrise-tools/datapi"
    render json: { 'message' => welcome_msg, 'environment' => Rails.env }
  end

end
