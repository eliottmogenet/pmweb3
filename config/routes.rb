Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :employers do
    resources :projects do
        member do
          post 'reset_time', to: "projects#reset_time"
        end
      resources :tasks do
        member do
          post 'done', to: "tasks#done"
        end
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
