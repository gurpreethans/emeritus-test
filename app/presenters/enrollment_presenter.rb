# frozen_string_literal: true

module EnrollmentPresenter
  def self.single(enrollment)
    {
      id: enrollment.id,
      name: enrollment.name,
      email: enrollment.email,
      status: enrollment.status
    }
  end

  def self.list(enrollments)
    enrollments.map do |enrollment|
      single(enrollment)
    end
  end
end
