class Weapon < ApplicationRecord
    has_many :movements, dependent: :restrict_with_error
    validates :model, :registration, presence: true
    attribute :borrowed, :boolean, default: false
  end