class Movement < ApplicationRecord
  enum movement_type: { loan: 'loan', return: 'return' }

  belongs_to :armeiro, class_name: 'Guard'
  belongs_to :guard,   class_name: 'Guard'
  belongs_to :weapon

  validates :movement_type, :date, :time, :ammo_count,
            :ammo_caliber, :magazine_count, presence: true

  validate :weapon_availability
  validate :return_validity
  after_create  :update_weapon_status

  private

  def weapon_availability
    if loan? && weapon.borrowed?
      errors.add(:weapon, 'já está emprestada a outro guarda')
    end
  end

  def return_validity
    return unless return?
    last_loan = Movement.loan.where(weapon: weapon, guard: guard).order(:date, :time).last
    if last_loan.nil?
      errors.add(:base, 'Não existe empréstimo desta arma para este guarda')
    end

    if (ammo_count > last_loan.ammo_count) || (magazine_count > last_loan.magazine_count)
      errors.add(:base, 'Devolução não pode ter mais munição ou carregadores que o emprestado')
    end

    if (ammo_count < last_loan.ammo_count) || (magazine_count < last_loan.magazine_count)
      errors.add(:justification, 'é obrigatória quando há falta de balas ou carregadores')
    end
  end

  def update_weapon_status
    weapon.update!(borrowed: loan?)
  end
end
