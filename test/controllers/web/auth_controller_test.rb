# frozen_string_literal: true

require 'test_helper'

class AuthControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'callback should auth existing user' do
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

    get callback_auth_url('github')
    assert { signed_in? }
  end

  test 'callback should create user' do
    auth_hash = {
      provider: 'github',
      uid: '',
      info: {
        email: 'test@example.com',
        name: ''
      },
      credentials: {
        token: 'token'
      }
    }

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    get callback_auth_url('github')
    assert { User.find_by(email: 'test@example.com') }
    assert { signed_in? }
  end

  test 'should logout' do
    sign_in(@user)
    get auth_logout_url

    assert { current_user.nil? }
  end
end
