FactoryBot.define do
  factory :batch do
    name { '2023' }
    association :course, factory: :course
  end
end