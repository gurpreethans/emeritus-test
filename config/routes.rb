# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: 'users', controllers:     { registrations: 'users/registrations',
                                                       confirmations: 'users/confirmations',
                                                       sessions: 'users/sessions',
                                                       passwords: 'users/passwords' }

  devise_scope :user do
    authenticated do
      root 'dashboard#index'
    end

    unauthenticated do
      root 'users/sessions#new', as: :unauthenticated_root
    end
  end

  resources :schools
  resources :school_admins
  resources :my_schools, only: %i[index edit update] do
    resources :courses do
      resources :batches do
        resources :enrollments, only: %i[index new create destroy] do
          member do
            get 'update_status', to: 'enrollments#update_status'
          end
        end
      end
    end
  end

  namespace :students do
    resources :courses, only: [:index] do
      resources :batches, only: [:index] do
        resources :enrollments, only: [:index] do
          collection do
            get 'enroll', to: 'enrollments#enroll'
            get 'disenroll', to: 'enrollments#disenroll'
          end
        end
      end
    end
  end
end
