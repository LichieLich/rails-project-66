# frozen_string_literal: true

module LinksHelper
  def link_to_check_commit(check)
    link_to(check.commit_id[0..6], "https://github.com/#{check.repository.full_name}/tree/#{check.commit_id}")
  end
end
