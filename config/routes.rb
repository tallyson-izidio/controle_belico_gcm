# config/routes.rb
Rails.application.routes.draw do
  devise_for :users, controllers: {
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    authenticated :user do
      root to: 'home#index', as: :authenticated_root
    end

    unauthenticated do
      # aqui apontamos para o form de login do Devise corretamente
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  root to: 'home#index' 
  
  resources :units
  resources :teams
  resources :guards
  resources :weapons
  resources :movements

  get 'up' => 'rails/health#show', as: :rails_health_check
  get 'home/index'
end
