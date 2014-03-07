SlotMachineApp::Application.routes.draw do
  root to: "games#index"

  resources :games, only: [:index, :create]
  resources :withdrawals, only: [:create]
  resources :users, only: [:update]

  get "admin/statistics", to: "admin#statistics"

end
