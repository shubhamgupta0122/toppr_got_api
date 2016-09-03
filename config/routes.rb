Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    resources :battles, only: [:index, :create, :show, :update, :destroy]
  end
  resources :battles
  root 'battles#index'
  get :stats , to: 'battles#stats'
  get :list  , to: 'battles#list'
  get :count , to: 'battles#count'
  get :search, to: 'battles#search'
end
