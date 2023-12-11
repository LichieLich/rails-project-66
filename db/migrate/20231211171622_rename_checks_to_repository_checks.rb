class RenameChecksToRepositoryChecks < ActiveRecord::Migration[7.0]
  def change
    rename_table :checks, :repository_checks
  end
end
