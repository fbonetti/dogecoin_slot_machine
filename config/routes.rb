SlotMachineApp::Application.routes.draw do
  root to: "games#new"

  resources :games, only: [:new, :create], path_names: {new: "play"}
  resources :withdrawals, only: [:create]
  resources :users, only: [:update]

end
