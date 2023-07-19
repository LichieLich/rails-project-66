# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      user = User.find_or_create_by auth_params

      user.nickname = auth['info']['nickname']
      user.name = auth['info']['name']
      user.email = auth['info']['email']
      user.image_url = auth['info']['image']
      user.token = auth['credentials']['token'] # Токен пользователя, потребуется нам позднее

      user.save!

      redirect_to :root
    end

    def logout
      session[:user_id] = nil
      redirect_to :root
    end
  end
end