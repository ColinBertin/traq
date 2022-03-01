class Contribution < ApplicationRecord
  belongs_to :user
  belongs_to :location

  validates :supply_type, presence: true
  validates :description, presence: true
end
