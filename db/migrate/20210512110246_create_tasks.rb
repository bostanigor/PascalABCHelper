class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :ref
      t.decimal :rating, precision: 10, scale: 2
      t.integer :successfull_attempts, default: 0
      t.integer :all_attempts, default: 0

      t.timestamps
    end
  end
end
