class AddErrorsCountToCheck < ActiveRecord::Migration[7.0]
  def change
    add_column :repository_checks, :errors_count, :integer
  end
end
