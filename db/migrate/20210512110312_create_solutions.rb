class CreateSolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :solutions do |t|
      t.boolean :is_successfull
      t.integer :attempts_count, default: 1
      t.datetime :last_attempt_at

      t.references :student, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
