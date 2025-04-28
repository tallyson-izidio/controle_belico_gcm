class Guard < ApplicationRecord
  belongs_to :team
  has_many :loans, class_name: 'Movement', foreign_key: :armeiro_id
  has_many :receives, class_name: 'Movement', foreign_key: :guard_id
  validates :full_name, :matricula, :porte_numero, :team, presence: true
end