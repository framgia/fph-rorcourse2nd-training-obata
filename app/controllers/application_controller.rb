class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  include SessionsHelper
  #applicationで設定することで、
  #SessionsHelperが全部のcontorollerで使える
end