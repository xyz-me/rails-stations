Rails.application.routes.draw do
  # 一覧画面
  get "/movies", to: "movies#index"
  get "/movies/:id", to: "movies#show"
  resources :movies, :schedule

  # 座席画面
  get '/sheets', to: "sheets#index"
  resources :sheets

  namespace :admin do
    resources :movies do
      resources :schedules, only: [ :show, :new, :create, :edit, :update, :destroy]
    end
  end

  # 管理者画面
  ## 一覧画面
  # get "/admin/movies/:id", to: "admin/movies#show"

  
  get "/admin/schedules", to: "admin/schedules#index"
  get "/admin/schedules/:id", to: "admin/schedules#edit"
  put "/admin/schedules/:id", to: "admin/schedules#update"
  delete "/admin/schedules/:id", to: "admin/schedules#destroy"

  ## 新規追加画面
  get "/admin/movies/new", to: "admin/movies#new"
  post "/admin/movies/", to: "admin/movies#create"

  ## 編集画面
  # get "/admin/movies/:id", to: "admin/movies#show"
  # get "/admin/movies/:id/edit", to: "admin/movies#edit"
  # put "/admin/movies/:id/", to: "admin/movies#update"
  # delete "/admin/movies/:id/", to: "admin/movies#delete"
  # get "/admin/movies/:id/schedules/new", to: "admin/movies#new_schedule"
  # post "/admin/schedules", to: "admin/movies#post_new_schedule"



  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
