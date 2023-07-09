# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  ADMIN = 'admin'
  SCHOOL_ADMIN = 'school_admin'
  STUDENT = 'student'

  enum :role, [ADMIN, SCHOOL_ADMIN, STUDENT]

  has_many :school_admins
  has_many :schools, through: :school_admins
  has_many :enrollments
  has_one :school_student
  has_one :school, through: :school_student

  scope :students, lambda {
    where(role: STUDENT)
  }

  scope :enrolled, lambda { |batch_id|
    enrollments.where(user_id: id, batch_id: batch_id).exists?
  }

  accepts_nested_attributes_for :school_student

  def admin?
    role == ADMIN
  end

  def school_admin?
    role == SCHOOL_ADMIN
  end

  def enrolled?(batch)
    enrollments.where(user_id: id, batch_id: batch.id).exists?
  end
end
