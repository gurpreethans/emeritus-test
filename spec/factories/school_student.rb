# frozen_string_literal: true

FactoryBot.define do
  factory :school_student do
    association :school, factory: :school
    association :user, factory: :user
  end
end
