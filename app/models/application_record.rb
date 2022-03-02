class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # geocoded_by :ip_address, :latitude => :lat, :longitude => :lon
  # after_validation :geocode
end
