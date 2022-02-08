Rails.application.routes.draw do
  mount ForestLiana::Engine => '/forest'
  devise_for :users, controllers: {
    registrations: "registrations",
    :omniauth_callbacks => "users/omniauth_callbacks"
  }

  devise_scope :user do
   get '/users/sign_out' => 'devise/sessions#destroy'
  end

  root to: 'pages#home'
  get 'reload', to: 'pages#reload'

  resources :projects do
    member do
      post 'join_puzzle', to: "projects#join_puzzle"
    end
    resources :tasks
    resources :topics do
      member do
        post 'reset_time', to: "topics#reset_time"
      end
    end
  end

  get "/projects/:uuid/join", to: "projects#join", as: :join_project

  resources :tasks, only: [] do
    member do
      patch :mark_as_public
      patch :mark_as_done
      patch :vote
      patch :archive
    end
  end

  resources :topics, only: [] do
    resources :user_topics, only: [:create]
  end
  #resources :employers do
    #resources :projects do
        #member do
          #post 'reset_time', to: "projects#reset_time"
        #end
      #resources :tasks do
        #member do
          #post 'done', to: "tasks#done"
        #end
      #end
    #end
  #end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

