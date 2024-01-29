# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :github_repository_api, -> { GithubRepositoryApiStub }
    register :repository_checker, -> { CheckRepositoryJobStub }
    register :bash_runner, -> { BashRunnerStub }
    register :check_notification_mailer, -> { CheckNotificationMailerStub }
  else
    register :github_repository_api, -> { GithubRepositoryApi }
    register :repository_checker, -> { CheckRepositoryJob }
    register :bash_runner, -> { BashRunner }
    register :check_notification_mailer, -> { CheckNotificationMailer }
  end
end
