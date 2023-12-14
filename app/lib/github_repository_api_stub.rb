# frozen_string_literal: true

class GithubRepositoryApiStub
  def self.client(_user); end

  def self.get_repository(_user, _id)
    mock_repository =
      JSON.parse(File.read("#{Rails.root}/test/fixtures/files/mocked_repository.json"))

    Sawyer::Resource.new(
      Sawyer::Agent.new('mock'),
      id: mock_repository['id'],
      name: mock_repository['name'],
      full_name: mock_repository['full_name'],
      language: mock_repository['language']
    )
  end

  def self.user_repositories(_user); end

  def self.get_last_commit(_user, _id); end

  def self.enable_webhook(_user, _name); end

  def self.delete_webhook(_user, _id); end
end
