# frozen_string_literal: true

module CoursePresenter
  def self.single(batch)
    {
      id: batch.id,
      course_id: batch.course_id,
      name: batch.name
    }
  end

  def self.list(batches)
    batches.map do |batch|
      single(batch)
    end
  end
end
