# frozen_string_literal: true

class EnrollStudents
  def self.call(batch, attributes, options = {})
    new(batch, attributes, options).call
  end

  def initialize(batch, attributes, options = {})
    @batch = batch
    @student_ids = attributes[:student_ids] || []
    @status = options[:status] || Enrollment::PENDING
  end

  def call
    ActiveRecord::Base.transaction do
      enroll_students
    end
  end

  def enroll_students
    return if @student_ids.empty?

    columns = %i[user_id batch_id status]

    values = @student_ids.map do |student_id|
      [student_id.to_i, @batch.id, @status]
    end

    Enrollment.import(
      columns, values, on_duplicate_key_update: [:status]
    )
  end
end
