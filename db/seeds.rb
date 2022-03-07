# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'yaml'

puts 'Cleaning database...'
User.destroy_all
Location.destroy_all
Contribution.destroy_all

# Create User
# Individual Contributor Profile

puts 'Creating users'
User.create!(email: "kimm@gmail.com", password:123456, admin:true)

User.create!(email: "colin@gmail.com", password:123456, admin:true)

User.create!(email: "takeshi@gmail.com", password:123456, admin:true)
# People who need help

User.create!(email: "doug@dmb.com", password:123456)

User.create!(email: "yann@yannify.com", password:123456)

User.create!(email: "louis@gmail.com", password:123456)

# NGO profile
User.create!(email: "redcross@donation.com", password:123456)

puts "... #{User.count} users has been created"

yml_file = YAML::load_file('shelters.yml')
yml_file.each do |row|
  Location.create(name: row["name"], address: row["address"],
    latitude: row["latitude"], longitude: row["longitude"], location_type: 2)
end

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

Location.create!(name: "Japanese Red Cross Society", address: "Shiba Daimon, Minato-ku, Tokyo",
  latitude: 40, longitude: 110, location_type: 1)

# Creating contributions

10.times do
  food = Contribution.new(supply_type: "Food", description: "I have 20 packs of instant noodles
    in my house that I would like to give away for free", quantity: 20)
    food.user = User.all.sample
    food.location = Location.all.sample
    food.save
  end

food = Contribution.new(supply_type: "Water", description: "I have 50 packs of water to give away.", quantity: 20)
food.user = User.all.sample
food.location = Location.all.sample
food.save

food = Contribution.new(supply_type: "Water", description: "I have 50 packs of instant noodle to give away.", quantity: 50)
food.user = User.all.sample
food.location = Location.all.sample
food.save

food = Contribution.new(supply_type: "First Aid", description: "I have some first aid to share.", quantity: 100)
food.user = User.all.sample
food.location = Location.all.sample
food.save

puts "#{Contribution.count} contributions have been created"

# Creating Comments

10.times do
com = Comment.create!(content: "Staff were super helpful!",
  location: Location.all.sample,
  user: User.all.sample)
end
puts "#{Comment.count} comments have been created"
