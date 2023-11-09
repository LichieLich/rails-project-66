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
    mocked_event = load_fixture('files/mocked_push_event.json')


    assert_difference('Check.count', 1) do
      post api_checks_url(payload: mocked_event)
    end
  end
end
