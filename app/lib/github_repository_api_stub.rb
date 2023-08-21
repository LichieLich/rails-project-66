# frozen_string_literal: true

class GithubRepositoryApiStub
  def self.client(_user)
  end
  
  def self.get_repository(_user, _id)
    mock_repository =
      JSON.parse(File.read("#{Rails.root}/test/fixtures/files/mocked_repository.json"))

    Sawyer::Resource.new(
      Sawyer::Agent.new('mock'),
      id: mock_repository['id'],
      name: mock_repository['name'],
      language: mock_repository['language'])
  end

  def self.user_repositories(_user)
  end
end