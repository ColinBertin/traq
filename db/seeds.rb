# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'yaml'

puts 'Cleaning database...'
# User.destroy_all
# Location.destroy_all
Contribution.destroy_all

# Create User
# Individual Contributor Profile
puts 'Creating users'
User.create!(email: "kimm@gmail.com", password:123456)

User.create!(email: "colin@gmail.com", password:123456)

User.create!(email: "takeshi@gmail.com", password:123456)

# People who need help

User.create!(email: "doug@dmb.com", password:123456)

User.create!(email: "yann@yannify.com", password:123456)

User.create!(email: "louis@gmail.com", password:123456)

# NGO profile
User.create!(email: "redcross@donation.com", password:123456)

puts "... #{User.count} users has been created"

yml_file = YAML::load_file('shelters.yml')
yml_file.each do |row|
  Location.create(name: row["name"], address: row["address"], location_type: 2)
end

puts "There are now #{Location.count} shelters"
puts 'Finished making shelters'

puts "Start making individual and NGO Locations"
# Creating Location for Individual Controbutor
Location.create!(name: "Marunochi Park", address: "129-1217, Marunochi Shimmarunochibirudeingu(2-kai) Chiyoda-ku, Tokyo",
location_type: 0)

Location.create!(name: "Shibuya Building", address: "1-39, Hiroo 1-chome, Shibuya-ku, Tokyo",
location_type: 0)

Location.create!(name: "Kanda Recreation Building", address: "3-3, Kanda Ogawamachi, Chiyoda-ku, Tokyo",
  location_type: 0)

Location.create!(name: "Setagaya Park", address: "262-1094, Ohara, Setagaya-ku, Tokyo",
  location_type: 0, user_id: User.first)

Location.create!(name: "Kanda Recreation Building", address: "3-3, Kanda Ogawamachi, Chiyoda-ku, Tokyo",
  location_type: 0, user_id: User.last)


# Creating Location for NGO

Location.create!(name: "Japanese Red Cross Society", address: "1-1-3, Shiba Daimon, Minato-ku, Tokyo 105-8521",
  location_type: 1)

Location.create!(name: "The Nippon Foundation", address: "1 Chome−2−2 Minato City, Akasaka,
  Tokyo 107-8404 Nihon Building", location_type: 1)

# Creating contributions

10.times do
 food = Contribution.new(supply_type: "Food", description: "I have 20 packs of instant noodles
    in my house that I would like to give away for free", quantity: 20)
    food.user = User.all.sample
    food.location = Location.all.sample
    food.save
  # Contribution.create!(supply_type: "Water", description: "I have some packs of water that I would like to give away", quantity: 50, user_id: rand(User.all.sample))
  # Contribution.create!(supply_type: "First Aid", description: "I have some first aid kits you can use", quantity: 15)
 end

  food = Contribution.new(supply_type: "Water", description: "I have 50 packs of instant water to give away.", quantity: 20)
  food.user = User.all.sample
  food.location = Location.all.sample
  food.save

  food = Contribution.new(supply_type: "First Aid", description: "I have some extra pain killers to give away.", quantity: 100)
  food.user = User.all.sample
  food.location = Location.all.sample
  food.save






end
