module V1
 class UsersController < ApplicationController
    skip_before_action :authorize_request, only: :create

    # POST /signup
    # return authenticated token upon signup
    def create
      #user = User.create!(user_params)
      user = User.new(email: params[:email], password: params[:password])

      if user.save!
        user.send_activation_email
        #UserMailer.account_activation(@user).deliver_now
        auth_token = AuthenticateUser.new(user.email, params[:password]).call
        response = { message: Message.account_created, auth_token: auth_token }
        json_response(response, :created)
      end
    end

    private

    def user_params
      params.permit(
        :email,
        :password
      )
    end
  end
end

