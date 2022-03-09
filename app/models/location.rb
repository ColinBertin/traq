class Location < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  belongs_to :user, optional: true
  has_many :contributions, dependent: :destroy
  accepts_nested_attributes_for :contributions
  has_many :comments, dependent: :destroy
  has_many :checkins, dependent: :destroy

  validates :name, presence: true

  enum location_type: {
    individual: 0,
    ngo: 1,
    shelter: 2
  }, _default: 0

  include PgSearch::Model
  pg_search_scope :global_search,
                  against: %i[address name],
                  associated_against: {
                    contributions: %i[supply_type]
                  },
                  using: {
                    tsearch: { prefix: true }
                  }
end
