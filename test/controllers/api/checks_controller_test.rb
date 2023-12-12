# frozen_string_literal: true

require 'test_helper'

class ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in(@user)
  end

  test 'should create check by api push' do
    mocked_event = JSON.parse load_fixture('files/mocked_push_event.json')

    assert_difference('Repository::Check.count', 1) do
      post api_checks_url, params: mocked_event
    end
  end
end
