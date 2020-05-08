Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :drivers 
  resources :passengers
  
  patch '/drivers/:id/toggle_available', to: 'drivers#toggle_available', as: 'toggle_available'
end
