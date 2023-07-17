# frozen_string_literal: true

class Web::HomeControllerTest < ActionDispatch::IntegrationTest
  test 'gets home page' do
    get root_url
    assert_response :success
  end
end
