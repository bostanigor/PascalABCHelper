class CreateStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :students do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.datetime :birthdate

      t.timestamps
    end
  end
end
