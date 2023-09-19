# frozen_string_literal: true

class RepositoryChecker
  def self.perform_check(check, repository_data)
    @repository_folder = "tmp/repositories/#{repository_data.name}"

    begin
      BashRunner.run("rm -r -f #{@repository_folder}")
      BashRunner.run('mkdir tmp/repositories')
      BashRunner.run("git clone #{repository_data.clone_url} #{@repository_folder}")
    rescue StandardError => e
      check.fail_clone!
      raise e
    end

    check.finish_cloning_repository!

    case repository_data.language.downcase
    when 'javascript'
      eslint_check
    else
      raise "#{repository_data.language} не поддерживается"
    end
  end

  def self.eslint_check
    BashRunner.run("eslint #{@repository_folder}/**/*.js --format json")
  end
end
