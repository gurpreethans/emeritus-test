class User < ApplicationRecord
  enum :kind, %i[student teacher teacher_student]

  has_many :teacher_enrollments, foreign_key: :user_id, class_name: 'Enrollment'
  has_many :teachers, through: :teacher_enrollments

  # has_and_belongs_to_many :teachers, join_table: 'enrollments', class_name: 'Enrollment', foreign_key: :user_id

  scope :favorites, -> { where(Enrollment.arel_table[:favorite].eq(true)) }
  scope :classmates, lambda { |user|
    joins(:teacher_enrollments).where(Enrollment.arel_table[:teacher_id].in(user.teachers.ids)).where.not(id: user.id)
  }

  has_many :student_enrollments, foreign_key: :teacher_id, class_name: 'Enrollment'
  has_many :students, through: :student_enrollments, source: :user

  validate :teacher_cannot_be_student
  validate :student_cannot_be_teacher

  def teacher_cannot_be_student
    errors.add(:kind, 'can not be student because is teaching in at least one program') if students.exists?
  end

  def student_cannot_be_teacher
    errors.add(:kind, 'can not be teacher because is studying in at least one program') if teachers.exists?
  end
end
