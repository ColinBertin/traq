class Location < ApplicationRecord
  belongs_to :user, optional: true
  has_many :contributions, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true
  # locations type enum? [contributor, NGO]
  enum location_type: {
    contributor: 0,
    ngo: 1,
    shelter: 2
  }, _default: 0
end
