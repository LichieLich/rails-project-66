class RemoveRepositoryFromRepositoryChecks < ActiveRecord::Migration[7.1]
  def change
    remove_column :repository_checks, :repository
  end
end
