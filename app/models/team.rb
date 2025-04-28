class Team < ApplicationRecord
  belongs_to :unit
  has_many :guards, dependent: :restrict_with_error
  validates :name, :unit, presence: true
end