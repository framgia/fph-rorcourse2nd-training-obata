class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :show, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @users =User.paginate(page: params[:page]) 
    # .pagenate - .allも含まれてる
  end
  
  def show
    @user = User.find(params[:id])
    #　params[:id]　=　DBのprimaryKey
  end

  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  #ユーザーが登録される時
  def create
    @user = User.new(user_params)
    #　User　=　モデル
    #　.new　=　class(設計図)の情報をobjectにする
    #　→これで、DBに情報入れれる状態にする

    if @user.save
      # INSERTと同じ
      #.save →  DBに情報入れた
       
      flash[:success] = "success!"
      #ポップアップ
       
      redirect_to root_url
      #前　ー　その情報のところにいく　=SHOWページにいく
      #メール認証追加後　ー　トップへ飛ぶ設定
    else
     render 'new'
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params) 
      redirect_to users_path 
    else
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
      redirect_to users_path
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    #後ろの４つ登録していいですよね？
    def logged_in_user
      unless logged_in?
        store_location
        # 飛び先のURLを要求（GETアクションの時のみ）
     
        flash[:danger] = "Please log in."
        redirect_to login_url
        # login_url = /login
        #ファルスだと、飛べる
        #loginしてると、希望のページに飛べる
        #つまり、current_userに情報が入ってるか？？
      end
    end
   
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end