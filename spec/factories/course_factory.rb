FactoryBot.define do
  factory :course do
    name { 'MBA' }
    description { '' }
    association :school, factory: :school
  end
end