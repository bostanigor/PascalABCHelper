class CreateAttempts < ActiveRecord::Migration[6.0]
  def change
    create_table :attempts do |t|
      t.text :code_text
      t.integer :status
      t.references :solution, null: false, foreign_key: true

      t.timestamps
    end
  end
end
