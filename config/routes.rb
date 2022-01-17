Rails.application.routes.draw do
  mount ForestLiana::Engine => '/forest'
  devise_for :users, controllers: {registrations: "registrations"}

  devise_scope :user do
   get '/users/sign_out' => 'devise/sessions#destroy'
  end

  root to: 'pages#home'

  resources :projects do
    member do
      post 'reset_time', to: "projects#reset_time"
    end
    resources :tasks
  end

  get "/projects/:uuid/join", to: "projects#join", as: :join_project

  resources :tasks, only: [] do
    member do
      patch :mark_as_public
      patch :mark_as_done
    end
  end
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

