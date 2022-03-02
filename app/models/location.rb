class Location < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  belongs_to :user, optional: true
  has_many :contributions, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true

  include PgSearch::Model
  # multisearchable against: [:contributions]

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  # locations type enum? [contributor, NGO]
  enum location_type: {
    contributor: 0,
    ngo: 1,
    shelter: 2
  }, _default: 0
end
