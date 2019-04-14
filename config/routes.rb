Rails.application.routes.draw do
  root 'games#create'
  post 'games', to: 'games#create'
  post 'games/:game_id/players', to: 'players#create'
  get 'games/:id', to: 'games#total_score'
  put 'games/:id', to: 'games#add_score'
end
