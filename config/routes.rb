Wd::Application.routes.draw do
  resource :home
  devise_for :users

  resources :subjects, :veil_passes, :users

  root :to => "homes#show"
end
