class AddGithubIdToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :github_id, :string
  end
end
