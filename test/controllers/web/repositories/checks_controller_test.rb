# frozen_string_literal: true

require 'test_helper'

class ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
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