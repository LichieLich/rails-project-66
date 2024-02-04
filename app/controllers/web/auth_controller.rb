# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      user_info = request.env['omniauth.auth']

      user = get_user(user_info)
      sign_in(user)
      user.save
      redirect_to :root
    rescue StandardError
      redirect_to :root, alert: t('navigation.errors.auth_error')
    end

    def logout
      sign_out
      redirect_to :root
    end

    private

    def get_user(user_info)
      user = User.find_or_initialize_by(email: user_info['info']['email'])
      user.nickname = user_info['info']['nickname']
      user.token = user_info['credentials']['token']
      user.github_id = user_info['uid']
      user
    end
  end
end
