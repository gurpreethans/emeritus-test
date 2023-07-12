class CreateSchoolStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :school_students do |t|
      t.references :user, null: false, foreign_key: true
      t.references :school, null: false, foreign_key: true

      t.timestamps
    end
  end
end
