class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.decimal :rating, precision: 10, scale: 2

      t.timestamps
    end
  end
end
