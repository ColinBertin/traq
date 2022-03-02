class Comment < ApplicationRecord
  belongs_to :location
  belongs_to :user

  validates :content, presence: true

  include PgSearch::Model
  # multisearchable against: [:contributions]
  end
