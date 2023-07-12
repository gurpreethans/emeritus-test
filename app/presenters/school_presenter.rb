# frozen_string_literal: true

module SchoolPresenter
  def self.single(school)
    {
      id: school.id,
      name: school.name,
      description: school.description
    }
  end

  def self.list(schools)
    schools.map do |school|
      single(school)
    end
  end
end
