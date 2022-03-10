class Contribution < ApplicationRecord
  belongs_to :user
  belongs_to :location

  validates :description, presence: true
  acts_as_taggable_on :tags

  SUPPLY_ICON = {
    'water' => 'fas fa-tint',
    'medicine' => 'fas fa-tablets',
    'food' => 'fas fa-cookie-bite',
    'sanitation' => 'fas fa-pump-medical',
    'others' =>  'fas fa-box-open'
  }

  enum supply_type:
  {
    Water: 0,
    Food: 1,
    Sanitation: 2,
    Medicine: 3,
    Others: 4
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
