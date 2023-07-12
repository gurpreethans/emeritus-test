# frozen_string_literal: true

class UpdateSchool
  attr_reader :school

  def self.call(school, attributes)
    new(school, attributes).call
  end

  def initialize(school, attributes)
    @school = school
    @attributes = attributes
  end

  def call
    ActiveRecord::Base.transaction do
      update_school
    end

    self
  end

  def update_school
    @school.update!(
      name: @attributes[:name],
      description: @attributes[:description]
    )
  end
end
