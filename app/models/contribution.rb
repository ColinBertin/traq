class Contribution < ApplicationRecord
  belongs_to :user
  belongs_to :location

  validates :supply_type, presence: true
  validates :description, presence: true
  acts_as_taggable_on :tags

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
