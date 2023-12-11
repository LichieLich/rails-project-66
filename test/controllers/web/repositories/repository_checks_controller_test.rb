# frozen_string_literal: true

require 'test_helper'

class RepositoryChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:one)
    @check = repository_checks(:one)
    @finished_check = repository_checks(:two)
    @user = users(:one)
    sign_in(@user)
  end

  test 'should show finished check' do
    get repository_check_url(@repository, @finished_check)
    assert_response :success
  end

  test 'should sredirect to repo unless check is finished' do
    get repository_check_url(@repository, @check)
    assert_redirected_to repository_url(@repository)
  end

  test 'should create check' do
    assert_difference('RepositoryCheck.count', 1) do
      post repository_checks_url(@repository)
    end
  end
end
