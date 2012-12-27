Wd::Application.routes.draw do
  devise_for :users

  resources :subjects

  root :to => "subjects#index"
end
