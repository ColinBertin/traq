class Comment < ApplicationRecord
  belongs_to :location
  belongs_to :user

  validates :content, presence: true
end
