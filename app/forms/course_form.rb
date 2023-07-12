# frozen_string_literal: true

class CourseForm
  include ActiveModel::Model

  attr_accessor :name, :description

  validates :name, presence: true

  def initialize(course, params = {})
    @name = params[:name] || course.name
    @description = params[:description] || course.description
    course.assign_attributes(attributes)
  end

  def attributes
    {
      name: name,
      description: description
    }
  end
end
