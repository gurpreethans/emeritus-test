# frozen_string_literal: true

class CreateCourse
  attr_reader :course

  def self.call(school, attributes)
    new(school, attributes).call
  end

  def initialize(school, attributes)
    @school = school
    @attributes = attributes
  end

  def call
    ActiveRecord::Base.transaction do
      @course = create_course
    end

    self
  end

  def create_course
    @school.courses.create!(
      name: @attributes[:name],
      description: @attributes[:description]
    )
  end
end
