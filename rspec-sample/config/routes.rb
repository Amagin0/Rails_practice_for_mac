Rails.application.routes.draw do
  get 'food_enquetes/index'
  get 'food_enquetes/show'
  get 'food_enquetes/new'
  get 'food_enquetes/edit'
  get 'food_enquetes/create'
  get 'food_enquetes/update'
  get 'food_enquetes/destroy'
  resources :gym_enquetes
  resources :food_enquetes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
