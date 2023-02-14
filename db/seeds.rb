require 'yaml'
require 'faker'

puts 'Cleaning database...'
Contribution.destroy_all
Checkin.destroy_all
Location.destroy_all
User.destroy_all

# Create User
puts 'test'
puts 'Creating users'
User.create!(email: "kimm@gmail.com", password:123456, admin:true)

User.create!(email: "colin@gmail.com", password:123456, admin:true)

User.create!(email: "takeshi@gmail.com", password:123456, admin:true)

# NGO profile
User.create!(email: "redcross@donation.com", password:123456, admin:true)

puts "... #{User.count} users has been created"
puts "Start making individual and NGO Locations"

Location.create!(name: "Marunochi Park", address: "Marunochi Shimmarunochibirudeingu(2-kai) Chiyoda-ku, Tokyo",
location_type: 2)

# Creating Location for Individual Controbutions

Location.create!(name: "Red Cross Kanda Distribution Tent", address: "Kanda Ogawamachi, Chiyoda-ku, Tokyo",
latitude: 35, longitude: 110, location_type: 0, tel: "035-6566-6566")

Location.create!(name: "Red Cross Setagaya Tent", address: "Ohara, Setagaya-ku, Tokyo",
latitude: 35, longitude: 110, location_type: 0,  tel: "035-6566-6566")

Location.create!(name: "Red Cross Heart", address: "Kanda Ogawamachi, Chiyoda-ku, Tokyo",
latitude: 37, longitude: 112, location_type: 0, tel: "035-6566-6566")

# Creating Location for NGO

redcross = Location.create!(name: "Tokyo Japanese Red Cross Relief Tent", address: "Shiba Daimon, Minato-ku, Tokyo",
  latitude: 40, longitude: 110, location_type: 1, tel: "035-6566-6545")

yml_file = YAML::load_file('shelters.yml')
yml_file.each do |row|
  Location.create(name: row["name"], address: row["address"],
    latitude: row["latitude"], longitude: row["longitude"], location_type: 2)
end

puts "There are now #{Location.count} shelters and NGO Points"
puts 'Finished making shelters and NGO Points'

# New checkin 目黒区立下目黒小学校 MEGUROKU RITSU SHIMOMEGURO SHOUGAKKOU
56.times do
  user = User.create(email:Faker::Internet.email, password: "newrandompassword")
    location = Location.where(name:"目黒区立下目黒小学校 MEGUROKU RITSU SHIMOMEGURO SHOUGAKKOU").first
    user.checkin = Checkin.new(user: user, location: location)
    user.save
end
puts "NEW ONE #{User.count} users has been created"

# 目黒区立田道小学校 MEGUROKU TATSUTA MICHI SHOUGAKKOU
  26.times do
  user = User.create(email:Faker::Internet.email, password: "newrandompassword")
    location = Location.where(name:"目黒区立田道小学校 MEGUROKU TATSUTA MICHI SHOUGAKKOU").first
    user.checkin = Checkin.new(user: user, location: location)
    user.save
end

# 目黒区立第三中学校 MEGUROKU RITSU DAISAN CHUUGAKKOU
  14.times do
  user = User.create(email:Faker::Internet.email, password: "newrandompassword")
    location = Location.where(name:"目黒区立第三中学校 MEGUROKU RITSU DAISAN CHUUGAKKOU").first
    user.checkin = Checkin.new(user: user, location: location)
    user.save
end

  # 特別養護老人ホーム中目黒 TOKUBETSU YOUGO ROUJIN HOME NAKAMEGURO
  69.times do
  user = User.create(email:Faker::Internet.email, password: "newrandompassword")
    location = Location.where(name:"特別養護老人ホーム中目黒 TOKUBETSU YOUGO ROUJIN HOME NAKAMEGURO").first
    user.checkin = Checkin.new(user: user, location: location)
    user.save
end

    # 品川区立第四日野小学校 SHINAGAWAKU RITSU DAIYOKKA NO SHOUGAKKOU
  70.times do
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

puts "#{Contribution.count} contributions have been created"

# Creating Comments

10.times do
com = Comment.create!(content: "Staff were super helpful!",
  location: Location.all.sample,
  user: User.all.sample)
end
puts "#{Comment.count} comments have been created"
