class UpdateRepositoryColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :repositories, :repository_github_id, :github_id
    add_column :repositories, :full_name, :text
  end
end
