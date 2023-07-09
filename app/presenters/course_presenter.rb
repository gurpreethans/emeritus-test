# frozen_string_literal: true

module CoursePresenter
  def self.single(course)
    {
      id: course.id,
      school_id: course.school_id,
      name: course.name,
      description: course.description
    }
  end

  def self.list(courses)
    courses.map do |course|
      single(course)
    end
  end
end
