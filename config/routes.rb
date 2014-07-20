Wd::Application.routes.draw do
  resource :home
  devise_for :users

  resources :subjects do
    resources :comments
  end

  resources :veil_passes, :users

  resource :searches
  resources :tags

  root :to => "homes#show"
end
