# frozen_string_literal: true

class CreateSchool
  attr_reader :school

  def self.call(attributes)
    new(attributes).call
  end

  def initialize(attributes)
    @attributes = attributes
  end

  def call
    ActiveRecord::Base.transaction do
      @school = create_school
    end

    self
  end

  def create_school
    School.create!(
      name: @attributes[:name],
      description: @attributes[:description]
    )
  end
end
