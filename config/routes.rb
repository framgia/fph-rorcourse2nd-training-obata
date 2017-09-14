Rails.application.routes.draw do

  # namespace :admin do
  #   get 'users/index'
  # end

  # namespace :admin do
  #   get 'users/new'
  # end

  # namespace :admin do
  #   get 'users/edit'
  # end

  # namespace :admin do
  #   get 'users/show'
  # end

  # get 'admin/categories'

  # get 'admin/users'

root 'static_pages#home'
  
get '/help', to:'static_pages#help', as:'help'
get '/about', to: 'static_pages#about' ,as:'about'
get '/contact', to: 'static_pages#contact' ,as:'contact'
#static_pagesはresourcesがないから、１つずつ設定しないといけない
  
get '/signup', to: 'users#new'
post '/signup', to: 'users#create'
#userでsignupというアドレスを作る

get    '/login',   to: 'sessions#new'
post   '/login',   to: 'sessions#create'
delete '/logout', to: 'sessions#destroy'

resources :users do
  member do
    get :following, :followers
  end
end
#followingとfollowersのuser個別ページで、userの情報も、followingも情報も持ってきつつ自由に扱うため

resources :relationships, only: [:create, :destroy]


namespace :admin do
  #ここをadminにすることで自動でログイン時の分別
    root 'dashboard#index'
    get 'dashboard/index'
    resources :users
    resources :categories
end



end
