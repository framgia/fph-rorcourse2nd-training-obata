module SessionsHelper
  # Log in the given user.
  def log_in(user)
    session[:user_id] = user.id
    # []　→　配列
    #sessionの中に配列を入れる
    #これでloginできる
  end
 
  #②　for rememberボックス　　トークンTO Cookies
  # remember a user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
   
  def current_user
    if(user_id = session[:user_id])
    #user_id にsessionがあるか？
    @current_user ||= User.find_by(id: user_id)
    #前提がTRUE
    #無駄にDBにアクセスしないようにするため
    # @current_user - ログインしてるユーザーの情報(今入れた！)
         
    elsif (user_id = cookies.signed[:user_id])
      #user_id にsessionがあるなし関係なく(elsif)
      #user_id にcookiesがあるか？(チェックしてるか)
      user = User.find_by(id: user_id)
      # 左に、引数を入れれる
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
        #クッキーからの、ユーザーの情報。
      end
    end
  end
 
  def logged_in?
    !current_user.nil?
    #current_userが空じゃないですよね？？
  end
 
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
   
  def log_out
    forget(current_user)
    session.delete(:user_id)
    # sessionのデータ削除
    @current_user = nil
  end
 
  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end
   
  #②
  #Redirects to dtored location (or to the default)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    # default - home page
    session.delete(:fowarding_url)
    # 蓄えていた"飛びたかった場所"は飛んだあとはもういらないから削除。
  end
   
  #①
  # Stores the URL trying to be accessed.
  # 行き先のURLを取得するために使う(GETの時のみ)
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end