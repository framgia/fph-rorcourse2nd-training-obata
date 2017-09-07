Rails.application.routes.draw do

root 'static_pages#home'
  
get '/help', to:'static_pages#help', as:'help'
get '/about', to: 'static_pages#about' ,as:'about'
get '/contact', to: 'static_pages#contact' ,as:'contact'
#static_pagesはresourcesがないから、１つずつ設定しないといけない
  
get '/signup', to: 'users#new'
post '/signup', to: 'users#create'
#userでsignupというアドレスを作る

resources :users
  
end
