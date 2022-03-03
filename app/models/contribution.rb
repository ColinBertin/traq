class Contribution < ApplicationRecord
  belongs_to :user
  belongs_to :location

  validates :supply_type, presence: true
  validates :description, presence: true
  acts_as_taggable_on :tags

  include PgSearch::Model
  pg_search_scope :global_search,
    against: [ :supply_type, :description, :location_id ],
    associated_against: {
      location: [ :address, :latitude, :longitude, :location_type]
    },
    using: {
      tsearch: { prefix: true }
    }
end
