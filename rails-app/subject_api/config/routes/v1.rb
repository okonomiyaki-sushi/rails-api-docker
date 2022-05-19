namespace :v1 do
  resources :sessions, only: [:create]
  resources :users,    only: [:create]
  resources :trades,   only: [:create, :update, :destroy] do
    member do
      post :purchase
    end
  end

  get "sample", to: "users#sample"
end
