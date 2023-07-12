FactoryBot.define do
  factory :enrollment do
    association :user, factory: :user
    association :batch, factory: :batch
    status { Enrollment::PENDING }
  end
end