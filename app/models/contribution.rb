class Contribution < ApplicationRecord
  belongs_to :user
  belongs_to :location

  validates :description, presence: true
  acts_as_taggable_on :tags

  enum supply_type:
  {
    water: 0,
    food: 1,
    sanitation: 2,
    medicine: 3,
    others: 4
  }

  include PgSearch::Model
  pg_search_scope :global_search,
                  against: %i[supply_type location_id],
                  associated_against: {
                    location: %i[address location_type]
                  },
                  using: {
                    tsearch: { prefix: true }
                  }
end
