Rails.application.routes.draw do
root 'static_pages#home'
  
get '/signup', to: 'users#new'
post '/signup', to: 'users#create'
#userでsignupというアドレスを作る

get '/login', to:'sessions#new'
post '/login', to:'sessions#create'
delete '/logout', to:'sessions#destroy'
#sessionsでlogin、logoutというアドレスを作る

resources :users

end
