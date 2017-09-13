class User < ApplicationRecord
  #—————
  #以下はサインアップのためです。—————
  #—————
  # サインアップのためのvalidation
  before_save { self.email = email.downcase }
  before_save { email.downcase! }
  
  validates :name, presence: true, length:{ maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length:{ maximum: 255 },
  format: { with: VALID_EMAIL_REGEX },
  uniqueness: { case_sensitive: false }
  has_secure_password
  #gem 'bcrypt','3.1.11'とbundle installが必須
  
  validates :password, presence: true, length: { minimum: 6 } ,allow_nil: true
  # presence: true　があるため、新規ユーザーはemptyではNG
  # ただし、既存ユーザーはすでにデータが存在するため、
  # allow_nil: true　でemptyでもOK。
  
  #—————
  #以下はフォロー/アンフォローのためです。—————
  #—————
  
    #フォローする設定ーーーーーーー
    #ーーーーーーーーーーーーーーー
    has_many :active_relationships,   
    #ここに本来ならモデルの名前が入る
    # Userは、active_relationships(イマジナリーテーブル)を持つことができる。という意味。
                                    class_name:  "Relationship",
                                    #テーブルRelationshipと繋げてる。
                                    foreign_key: "follower_id",
                                    #結論　→　follower_id(フォローしてる人一覧)と結びつける
                                    dependent:   :destroy
                                    #親が死んだら、子も死ぬ
    # 結論、active_relationshipsは、「フォローしてる人(全員)(IDのみ)」
                                    
    has_many :following, through: :active_relationships, source: :followed
    # following(フォローしてる)もイマジナリーテーブル
    # followingは情報が１つだけ。(active_relationshipsはたくさん情報が入ってる)
    # through　-　あるテーブルから情報を引っ張ってくる
    # 結論、followingは、「フォローしてる特定の１人の情報」
    
      #フォローされる設定ーーーーーーー
    #ーーーーーーーーーーーーーーー
    has_many :passive_relationships, class_name:  "Relationship",
                                     foreign_key: "followed_id",
                                     dependent:   :destroy
    has_many :followers, through: :passive_relationships, source: :follower
  
    # 結論、passive_relationships、「だれにフォローされてる(全員)(IDのみ)」っていうだけ  
    # 結論、followersは、「だれフォローされてる(特定の１人)(名前やE-mailなどの情報)」っていうだけ
    
    #状態を聞くアクションメソッドは、親側(直接MODELに命令を下さない側)で行う
    #まあ、単純にユーザー通しの関係性(リレーション)だから、主語はユーザー。
  
  #—————
  #以下はリメンバーのためです。—————
  #—————
  attr_accessor :remember_token
  #トークン(ランダム)をDBにアクセスせずに自動発行

  # check botton remember system
  # Returns the hash digest of the given string
  # hushを作る　self.digest(string)　acitionを作る
  #データベースに関するactionは、モデルで作る。
 
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
    #暗号化のためのコード
  end

  #⓪　for rememberボックス　　token作る
  #Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  # tokenはモデルで作られる
  # User.new_token　- ランダム文字列

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    #update_attributeは、:remember_digestに、User.digest(remember_token)を入れる。
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end  
  
  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
 
end