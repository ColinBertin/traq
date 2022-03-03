class Contribution < ApplicationRecord
  belongs_to :user
  belongs_to :location

  validates :supply_type, presence: true
  validates :description, presence: true

  include PgSearch::Model
  pg_search_scope :global_search,
    against: [ :supply_type, :description ],
    associated_against: {
      location: [ :address]
    },
    using: {
      tsearch: { prefix: true }
    }
end
