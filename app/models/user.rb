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
 
end