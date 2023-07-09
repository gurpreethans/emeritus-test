# frozen_string_literal: true

class Course < ApplicationRecord
  belongs_to :school
  has_many :batches
end
