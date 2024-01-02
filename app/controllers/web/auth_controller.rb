# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      user_info = request.env['omniauth.auth']

      user = get_user(user_info)
      update_user(user, user_info)
      sign_in(user)
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
      User.find_or_create_by(github_id: user_info['uid']) do |user|
        user.nickname = user_info['info']['nickname']
        user.email = user_info['info']['email']
        user.token = user_info['credentials']['token']
        user.github_id = user_info['uid']
      end
    end

    def update_user(user, user_info)
      user.update(
        nickname: user_info['info']['nickname'],
        email: user_info['info']['email'],
        token: user_info['credentials']['token']
      )
    end
  end
end
