Wd::Application.routes.draw do
  devise_for :users

  resources :subjects, :veil_passes

  root :to => "subjects#index"
end
