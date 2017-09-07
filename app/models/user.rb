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
  
  # before
  # validates :password, presence: true, length: { minimum: 6 
  # after
  validates :password, presence: true, length: { minimum: 6 } ,allow_nil: true
  # presence: true　があるため、新規ユーザーはemptyではNG
  # ただし、既存ユーザーはすでにデータが存在するため、
  # allow_nil: true　でemptyでもOK。

end