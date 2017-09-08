class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
       #その"該当するemail"って、、
       #ユーザーが存在する？
       #パスワードあってる？
       #sessionのパスと、DBのパスは同じ？
       #(authenticate- モデルのhas_secure_passwordがあるから使える)
       #つまり、フォームに入れた情報大丈夫？ってこと。
        log_in @user
       #　セッションヘルパーの、log_in(user)を使ってる
       #すでに有効アカウント？# ここで、いわゆる"ログインした"って状態になって。。
       #params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
  def remember
    #①　for rememberボックス　　トークンTO database
        
    #1. Create token  
    self.remember_token = User.new_token   
    
    update_attribute(:remember_digest, User.digest(remember_token))
    # ":remember_digest"(DBの中のカラム)　に、"User.digest(remember_token)"（暗号化されたランダム文字列）を入れる。
    # "attribute = カラム
    # digest - 暗号化
    # モデルで作った、self.digest(string)を使って暗号化
    
  end
end