class AddSchoolToCourses < ActiveRecord::Migration[7.0]
  def change
    add_reference :courses, :school, null: false, foreign_key: true
  end
end
