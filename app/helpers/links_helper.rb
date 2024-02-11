# frozen_string_literal: true

module LinksHelper
  def link_to_check_commit(check)
    link_to(check.commit_id[0..6], "https://github.com/#{check.repository.full_name}/tree/#{check.commit_id}")
  end

  def link_to_file(check, file_path)
    link_to(file_path, "https://github.com/#{check.repository.full_name}/blob/#{check.commit_id}/#{file_path}")
  end
end
