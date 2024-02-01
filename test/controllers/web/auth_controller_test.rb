# frozen_string_literal: true

require 'test_helper'

class AuthControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)

    auth_hash = {
      provider: 'github',
      uid: @user.github_id,
      info: {
        email: @user.email,
        name: @user.nickname
      },
      credentials: {
        token: @user.token
      }
    }

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)
  end

  test 'callback should auth user' do
    get callback_auth_url('github')
    assert { current_user.id == @user.id }
  end

  test 'should logout' do
    sign_in(@user)
    get auth_logout_url

    assert { current_user.nil? }
  end
end
