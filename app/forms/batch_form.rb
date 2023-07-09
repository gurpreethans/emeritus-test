# frozen_string_literal: true

class BatchForm
  include ActiveModel::Model

  attr_accessor :name

  validates :name, presence: true

  def initialize(batch, params = {})
    @name = params[:name] || batch.name
    batch.assign_attributes(attributes)
  end

  def attributes
    {
      name: name
    }
  end
end
