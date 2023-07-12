FactoryBot.define do
  factory :student, class: User do
    name { 'Student' }
    email { 'student@example.com' }
    password { 'Hello123' }
    role { User::STUDENT }
  end

  factory :admin, class: User do
    name { 'Admin' }
    email { 'admin@example.com' }
    password { 'Hello123' }
    role { User::ADMIN }
  end

  factory :school_admin_user, class: User do
    name { 'SchoolAdmin' }
    email { 'school_admin@example.com' }
    password { 'Hello123' }
    role { User::SCHOOL_ADMIN }
  end
end