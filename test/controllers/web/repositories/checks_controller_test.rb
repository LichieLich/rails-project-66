# frozen_string_literal: true

require 'test_helper'

class ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    p '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    p ENV.fetch('BASE_URL', nil)
    @repository = repositories(:one)
    @check = checks(:one)
    @user = users(:one)
    sign_in(@user)
  end

  test 'should show test' do
    get repository_check_url(@repository, @check)
    assert_response :success
  end
end
