Rails.application.routes.draw do
  devise_for :users
  root 'candidates#index'
  get 'candidates/:candidate_id/donations', to: "donations#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
