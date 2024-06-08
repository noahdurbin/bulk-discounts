Rails.application.routes.draw do
  resources :merchants, only: [:show] do
    resources :dashboard, only: [:index]
    resources :items, except: [:destroy]
    resources :item_status, only: [:update]
    resources :invoices, only: %i[index show update]
    resources :discounts, only: %i[index show new create destroy]
  end

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :merchants, except: [:destroy]
    resources :merchant_status, only: [:update]
    resources :invoices, except: %i[new destroy]
  end
end
