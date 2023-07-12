# frozen_string_literal: true

module StudentPresenter
  def self.single(student)
    {
      id: student.id,
      name: student.name,
      email: student.email
    }
  end

  def self.list(students)
    students.map do |student|
      single(student)
    end
  end
end
