# frozen_string_literal: true

class SchoolStudent < ApplicationRecord
  belongs_to :user
  belongs_to :school
end
