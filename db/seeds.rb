# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


User.create!(name: "caster",
             email: "exampleexample@example.com",
             password: "example",
             password_confirmation: "example",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now
             #メール認証
             
             )
             
             
      
10.times do |n|
# this is loop
 name = Faker::Name.name
 email = "user-#{n+1}@example.com"
 password = "password"
 User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now
              )
end


# Following relationships
users = User.all
#fromユーザーテーブル

user  = users.first
following = users[2..50]
#userのIDの２から５０
followers = users[3..40]
#userのIDの３から４０

following.each { |followed| user.follow(followed) }
#followingの単数系がfollowed
followers.each { |follower| follower.follow(user) }
#フォローイングに関するseeds
