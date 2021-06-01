class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.integer :retry_interval
      t.integer :code_text_limit, null: true
      t.integer :singleton_guard, default: 0, unique: true

      t.timestamps
    end
  end
end
