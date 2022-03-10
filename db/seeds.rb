# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'yaml'
require 'faker'

puts 'Cleaning database...'
Contribution.destroy_all
Checkin.destroy_all
Location.destroy_all
User.destroy_all

# Create User
# Individual Contributor Profile

# Random  user for checking in

# Creating user and checkin for :
# 目黒区立下目黒小学校 MEGUROKU RITSU SHIMOMEGURO SHOUGAKKOU


puts 'Creating users'
User.create!(email: "kimm@gmail.com", password:123456, admin:true)

User.create!(email: "colin@gmail.com", password:123456, admin:true)

User.create!(email: "takeshi@gmail.com", password:123456, admin:true)
# People who need help

User.create!(email: "doug@dmb.com", password:123456)

User.create!(email: "yann@yannify.com", password:123456)

User.create!(email: "louis@gmail.com", password:123456)

# NGO profile
User.create!(email: "redcross@donation.com", password:123456, admin:true)

puts "... #{User.count} users has been created"

# yml_file = YAML::load_file('shelters.yml')
# yml_file.each do |row|
#   Location.create(name: row["name"], address: row["address"],
#     latitude: row["latitude"], longitude: row["longitude"], location_type: 2)
# end

Location.create!(name: "Marunochi Park", address: "Marunochi Shimmarunochibirudeingu(2-kai) Chiyoda-ku, Tokyo",
location_type: 2)
puts "There are now #{Location.count} shelters"
puts 'Finished making shelters'
puts "Start making individual and NGO Locations"
# Creating Location for Individual Controbutor
Location.create!(name: "Marunochi Park", address: "Marunochi Shimmarunochibirudeingu(2-kai) Chiyoda-ku, Tokyo",
location_type: 0)

Location.create!(name: "Shibuya Building", address: "Hiroo 1-chome, Shibuya-ku, Tokyo",
  location_type: 0)

  Location.create!(name: "Kanda Recreation Building", address: "Kanda Ogawamachi, Chiyoda-ku, Tokyo",
  location_type: 0)

  Location.create!(name: "Setagaya Park", address: "Ohara, Setagaya-ku, Tokyo",
  location_type: 0, user_id: User.first)

  Location.create!(name: "Kanda Recreation Building", address: "Kanda Ogawamachi, Chiyoda-ku, Tokyo",
  location_type: 0, user_id: User.last)

  # Creating Location for NGO

redcross = Location.create!(name: "Japanese Red Cross Society", address: "Shiba Daimon, Minato-ku, Tokyo",
  latitude: 40, longitude: 110, location_type: 1)

  yml_file = YAML::load_file('shelters.yml')
  yml_file.each do |row|
    Location.create(name: row["name"], address: row["address"],
      latitude: row["latitude"], longitude: row["longitude"], location_type: 2)
  end

  # New checkin 目黒区立下目黒小学校 MEGUROKU RITSU SHIMOMEGURO SHOUGAKKOU
  1556.times do
    user = User.create(email:Faker::Internet.email, password: "newrandompassword")
      location = Location.where(name:"目黒区立下目黒小学校 MEGUROKU RITSU SHIMOMEGURO SHOUGAKKOU").first
      user.checkin = Checkin.new(user: user, location: location)
      user.save
  end
  puts "NEW ONE #{User.count} users has been created"

  # 目黒区立田道小学校 MEGUROKU TATSUTA MICHI SHOUGAKKOU
    256.times do
    user = User.create(email:Faker::Internet.email, password: "newrandompassword")
      location = Location.where(name:"目黒区立田道小学校 MEGUROKU TATSUTA MICHI SHOUGAKKOU").first
      user.checkin = Checkin.new(user: user, location: location)
      user.save
  end

  # 目黒区立第三中学校 MEGUROKU RITSU DAISAN CHUUGAKKOU
    1754.times do
    user = User.create(email:Faker::Internet.email, password: "newrandompassword")
      location = Location.where(name:"目黒区立第三中学校 MEGUROKU RITSU DAISAN CHUUGAKKOU").first
      user.checkin = Checkin.new(user: user, location: location)
      user.save
  end

    # 特別養護老人ホーム中目黒 TOKUBETSU YOUGO ROUJIN HOME NAKAMEGURO
    469.times do
    user = User.create(email:Faker::Internet.email, password: "newrandompassword")
      location = Location.where(name:"特別養護老人ホーム中目黒 TOKUBETSU YOUGO ROUJIN HOME NAKAMEGURO").first
      user.checkin = Checkin.new(user: user, location: location)
      user.save
  end

      # 品川区立第四日野小学校 SHINAGAWAKU RITSU DAIYOKKA NO SHOUGAKKOU
    780.times do
    user = User.create(email:Faker::Internet.email, password: "newrandompassword")
      location = Location.where(name:"品川区立第四日野小学校 SHINAGAWAKU RITSU DAIYOKKA NO SHOUGAKKOU").first
      user.checkin = Checkin.new(user: user, location: location)
      user.save
  end

# Creating contributions
10.times do
  food = Contribution.new(supply_type: 1, description: "I have 20 packs of instant noodles
    in my house that I would like to give away for free", quantity: 20)
    food.user = User.all.sample
    food.location = Location.all.sample
    food.save
  end

  water = Contribution.new(supply_type: 2, description: "We have 500 litres of water", quantity: 500)
  water.user = User.all.sample
  water.location = Location.all.sample
  water.save

# food = Contribution.new(supply_type: 0, description: "I have some first aid to share.", quantity: 100)
# food.user = User.all.sample
# food.location = Location.all.sample
# food.save

puts "#{Contribution.count} contributions have been created"

# Creating Comments

10.times do
com = Comment.create!(content: "Staff were super helpful!",
  location: Location.all.sample,
  user: User.all.sample)
end
puts "#{Comment.count} comments have been created"
