Smashthestack::Application.routes.draw do
 devise_for :users, path: '', controllers: { sessions: 'sessions' }, path_names: {sign_in: 'login', sign_out: 'logout'}, sign_out_via: [:post, :delete, :get]
  
  root to: "main#show"
  match '/irc', to: 'main#irc', as: 'irc'
  match '/faq', to: 'main#faq', as: 'faq'
  match '/contact', to: 'main#contact', as: 'contact'
  match '/disclaimer', to: 'main#disclaimer', as: 'disclaimer'
 
  resources :wargames do
    get 'irc'
  end
  
  authenticate do
    resources :admins
  end
end
