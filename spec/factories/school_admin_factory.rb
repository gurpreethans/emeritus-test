FactoryBot.define do
  factory :school_admin do
    association :school, factory: :school
    association :user, factory: :user
  end
end