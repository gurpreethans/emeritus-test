# frozen_string_literal: true

class UpdateBatch
  attr_reader :batch

  def self.call(batch, attributes)
    new(batch, attributes).call
  end

  def initialize(batch, attributes)
    @batch = batch
    @attributes = attributes
  end

  def call
    ActiveRecord::Base.transaction do
      update_batch
    end

    self
  end

  def update_batch
    @batch.update!(
      name: @attributes[:name]
    )
  end
end
