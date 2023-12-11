class AddColumnsToRepositoryChecks < ActiveRecord::Migration[7.0]
  def change
    add_column :repository_checks, :passed, :boolean
    rename_column :repository_checks, :status, :aasm_state
  end
end
