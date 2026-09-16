Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  scope "api", module: "api", as: "api", defaults: { format: :json } do
    resource :registration, only: :create
    resource :session, only: %i[create destroy]
    resource :me, only: %i[show update destroy], controller: "me"
    resources :password_resets, only: %i[create update], param: :token
    get "home" => "home#show"
    get "interests" => "interests#index"

    resources :places, only: %i[index show], param: :username do
      get :random, on: :collection
      resources :notes, only: %i[index show]
      resources :guestbook_entries, path: "guestbook", only: %i[index create destroy]
    end

    namespace :my do
      resource :place, only: %i[show update] do
        resource :avatar, only: %i[update destroy]
      end
      resources :blocks, only: %i[create update destroy] do
        put :order, on: :collection
      end
      resources :uploads, only: %i[create destroy]
      resources :notes, only: %i[create update destroy]
      resources :guestbook_entries, path: "guestbook", only: %i[index update destroy]
      resources :neighbours, only: %i[index create update destroy], param: :username do
        put :order, on: :collection
      end
    end
  end
end
