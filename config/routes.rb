Rails.application.routes.draw do
  resources :battles
  root 'battles#index'
  get :stats , to: 'battles#stats'
  get :list  , to: 'battles#list'
  get :count , to: 'battles#count'
  get :search, to: 'battles#search'
end
