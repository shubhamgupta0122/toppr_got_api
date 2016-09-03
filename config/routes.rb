Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    resources :battles, only: [:index, :create, :show, :update, :destroy]
    get :stats, to: 'battles#stats'
    get :list,  to: 'battles#list'
  end
  resources :battles
  root 'battles#index'
end
