# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'home#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    get 'auth/logout', to: 'auth#logout'

    resources :repositories, only: %i[create destroy index new show] do
      resources :checks, only: %i[create show], module: :repositories
    end
  end

  namespace :api do
    resources :checks, only: %i[create]
  end
end
