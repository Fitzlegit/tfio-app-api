class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  # calls the authicate user class and assigns it to command
  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])

    # checks command is false or true authorizes or rejects request
    if command.success?
      render json: {auth_token: command.result }
    else
      render json: { error: command.errors }, status: :unauthrized
    end
  end
end
