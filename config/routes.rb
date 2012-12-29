Wd::Application.routes.draw do
  resource :home
  devise_for :users

  resources :subjects, :veil_passes

  root :to => "homes#show"
end
