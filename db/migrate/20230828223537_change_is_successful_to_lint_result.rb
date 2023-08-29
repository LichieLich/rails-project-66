class ChangeIsSuccessfulToLintResult < ActiveRecord::Migration[7.0]
  def change
    rename_column :checks, :is_successful, :linter_result
    change_column :checks, :linter_result, :text
  end
end
