# frozen_string_literal: true

class CreateBatch
  attr_reader :batch

  def self.call(school, attributes)
    new(school, attributes).call
  end

  def initialize(school, attributes)
    @school = school
    @attributes = attributes
  end

  def call
    ActiveRecord::Base.transaction do
      @batch = create_batch
    end

    self
  end

  def create_batch
    @school.batches.create!(
      name: @attributes[:name]
    )
  end
end
