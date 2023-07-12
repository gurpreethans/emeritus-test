# School Management App

App has three type of roles `Admin`, `School Admin` and `Student`. All three roles have different controls and limitations.

## Features

- Admins have full control over the system and can create schools and SchoolAdmins.
- School Admins can update information about the school.
- School Admins can create course, batches and enroll students to the batches.
- School Admins can approve or deny enrolment requests made by students
- Students can raise a request to enrol in a batch.
- Students from the same batch can see their classmates and their progress

## Tech Stack

- Rails 7
- Ruby 2.7.5
- Sqlite 3
- Devise
- jQuery
- Bootstrap
- Multi JSON
- Active Record Import



## Installation and Setup

```sh
git clone git@github.com:gurpreethans/emeritus-test.git
cd emeritus-test
Install and Setup Ruby 2.7.5 - Rbenv or RVM
gem install bundler
bundle install
rails db:setup
rails s
```

## Run Tests
```sh
bundle exec rspec spec
```

## To Do List
- Add pagination to the listing page and API
- Integrate devise-jwt for API authentication
- Write test cases
- Improve directory structure
- Integrate parallet testing for performance
- Integrate devise invitable and letter opener web gem for mails
- Add breadcrumbs to the pages

## Test Credentials
- Admin - admin@gmail.com / Hello123
- School Admin Password - Hello123
