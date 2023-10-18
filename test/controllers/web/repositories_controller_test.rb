# frozen_string_literal: true

require 'test_helper'

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:one)
    @user = users(:one)
    sign_in(@user)
  end

  test 'should get index' do
    get repositories_url
    assert_response :success
  end

  test 'should get new' do
    get new_repository_url
    assert_response :success
  end

  test 'should create repository' do
    response_body = load_fixture('files/mocked_repository.json')
    mocked_json_response = JSON.parse(response_body)

    post repositories_path(repository: { repository_github_id: mocked_json_response['id'] })

    created_repository = Repository.find_by!(
      name: mocked_json_response['name'],
      language: mocked_json_response['language']
    )

    assert { created_repository }
    assert_redirected_to repository_url(Repository.last)
  end

  test 'should show repository' do
    get repository_url(@repository)
    assert_response :success
  end

  test 'should get edit' do
    get edit_repository_url(@repository)
    assert_response :success
  end

  test 'should update repository' do
    patch repository_url(@repository), params: { repository: { name: @repository.name, user_id: @repository.user_id } }
    assert_redirected_to repository_url(@repository)
  end

  test 'should destroy repository' do
    assert_difference('Repository.count', -1) do
      delete repository_url(@repository)
    end

    assert_redirected_to repositories_url
  end
end