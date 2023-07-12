class CreateEnrollments < ActiveRecord::Migration[7.0]
  def change
    create_table :enrollments do |t|
      t.integer :user_id, null: false
      t.integer :batch_id, null: false
      t.integer :status, limit: 2, default: 0, null: false

      t.timestamps
    end

    add_index :enrollments, [:user_id, :batch_id], unique: true
  end
end
