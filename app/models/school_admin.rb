# frozen_string_literal: true

class SchoolAdmin < ApplicationRecord
  belongs_to :user
  belongs_to :school

  delegate :name, :email, to: :user
  delegate :name, to: :school, prefix: :school

  scope :valid_admin, lambda { |user_id, school_id|
    exists?(user_id: user_id, school_id: school_id)
  }
end
