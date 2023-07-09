# frozen_string_literal: true

class UpdateCourse
  attr_reader :course

  def self.call(course, attributes)
    new(course, attributes).call
  end

  def initialize(course, attributes)
    @course = course
    @attributes = attributes
  end

  def call
    ActiveRecord::Base.transaction do
      update_course
    end

    self
  end

  def update_course
    @course.update!(
      name: @attributes[:name],
      description: @attributes[:description]
    )
  end
end
