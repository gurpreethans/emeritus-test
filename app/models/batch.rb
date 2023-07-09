# frozen_string_literal: true

class Batch < ApplicationRecord
  belongs_to :course
  has_many :enrollments
end
