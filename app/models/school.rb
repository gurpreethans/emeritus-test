# frozen_string_literal: true

class School < ApplicationRecord
  has_many :school_admins
  has_many :users, through: :school_admins
  has_many :courses, dependent: :destroy
end
