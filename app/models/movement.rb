class Movement < ApplicationRecord
  enum movement_type: { emprestimo: 'emprestimo', devolucao: 'devolucao' }

  # Associações
  belongs_to :armeiro, class_name: 'Guard'
  belongs_to :guard,   class_name: 'Guard'
  belongs_to :weapon

  # Validações básicas
  validates :movement_type, :date, :time,
            :ammo_count, :ammo_caliber, :magazine_count,
            presence: true

  # Validações específicas
  validate :weapon_availability,         if: -> { emprestimo? }
  validate :weapon_valid_for_return,     if: -> { devolucao? }
  validate :justification_if_shortage,   if: -> { devolucao? }

  # Após criar, atualiza o status da arma
  after_create :update_weapon_status

  private

  # Só para empréstimo: arma não pode já estar emprestada
  def weapon_availability
    if weapon.nil?
      errors.add(:weapon, 'não selecionada')
    elsif weapon.borrowed?
      errors.add(:weapon, 'já está emprestada a outro guarda')
    end
  end

  # Só para devolução: arma deve estar emprestada e ter sido emprestada a este guarda
  def weapon_valid_for_return
    unless weapon&.borrowed?
      errors.add(:weapon, 'não pode ser devolvida, dados inconsistentes')
      return
    end

    last_loan = Movement.emprestimo
                       .where(weapon: weapon)
                       .order(:date, :time)
                       .last

    if last_loan.nil? || last_loan.guard != guard
      errors.add(:weapon, 'não pode ser devolvida, dados inconsistentes')
    end
  end

  # Só para devolução: se devolveu com menos balas/carregadores, justificativa é obrigatória
  def justification_if_shortage
    last_loan = Movement.emprestimo
                       .where(weapon: weapon, guard: guard)
                       .order(:date, :time)
                       .last
    return unless last_loan

    balas_diff  = last_loan.ammo_count      - ammo_count
    cargas_diff = last_loan.magazine_count - magazine_count

    if (balas_diff.positive? || cargas_diff.positive?) && justification.blank?
      errors.add(:justification, 'é obrigatória quando há falta de balas ou carregadores')
    end
  end

  # Marca a arma como emprestada ou não, de acordo com o movimento
  def update_weapon_status
    weapon.update!(borrowed: emprestimo?)
  end
end
