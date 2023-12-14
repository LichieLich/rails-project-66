class AddUrlsToRepository < ActiveRecord::Migration[7.0]
  def change
    add_column :repositories, :git_url, :string
    add_column :repositories, :ssh_url, :string
  end
end
