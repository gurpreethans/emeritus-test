class CreateSchoolAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :school_admins do |t|
      t.integer :school_id
      t.integer :user_id

      t.timestamps
    end
  end
end
