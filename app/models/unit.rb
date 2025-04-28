class Unit < ApplicationRecord
    has_many :teams, dependent: :restrict_with_error
    validates :name, presence: true
  end
