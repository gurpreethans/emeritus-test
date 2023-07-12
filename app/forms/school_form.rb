# frozen_string_literal: true

class SchoolForm
  include ActiveModel::Model

  attr_accessor :name, :description

  validates :name, presence: true

  def initialize(school, params = {})
    @name = params[:name] || school.name
    @description = params[:description] || school.description
    school.assign_attributes(attributes)
  end

  def attributes
    {
      name: name,
      description: description
    }
  end
end
