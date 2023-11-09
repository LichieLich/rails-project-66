# frozen_string_literal: true

require 'test_helper'

class ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:one)
    @check = checks(:one)
    @user = users(:one)
    sign_in(@user)
  end

  test 'should create check' do
    assert_difference('Check.count', 1) do
      post repository_checks_url(@repository)
    end
  end
end
