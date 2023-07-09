# frozen_string_literal: true

class Enrollment < ApplicationRecord
  PENDING = 'pending'
  APPROVED = 'approved'
  REJECTED = 'rejected'

  enum :status, [PENDING, APPROVED, REJECTED]

  belongs_to :user
  belongs_to :batch

  delegate :name, :email, to: :user
end
