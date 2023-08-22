class CreateChecks < ActiveRecord::Migration[7.0]
  def change
    create_table :checks do |t|
      t.string :status
      t.string :commit_id
      t.boolean :is_successful
      t.belongs_to :repository, index: true, foreign_key: true

      t.timestamps
    end
  end
end
