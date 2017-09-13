class RelationshipsController < ApplicationController
  before_action :logged_in_user
  
  def create
   @user = User.find(params[:followed_id])
   #followed_id - 誰か
   current_user.follow(@user)
   #ユーザーコントローラーのfollow()
   
   #java script---
   respond_to do |format|
    format.html { redirect_to @user }
    #作った後、リダイレクト
    format.js
   end
   #java script---
   
   
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    
    respond_to do |format|
    format.html { redirect_to user }
    format.js
   end
   
  end

end