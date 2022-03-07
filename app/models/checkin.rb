class Checkin < ApplicationRecord
  belongs_to :location
  belongs_to :user
end
