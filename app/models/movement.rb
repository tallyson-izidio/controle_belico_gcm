class Movement < ApplicationRecord
  enum movement_type: { emprestimo: 'emprestimo', devolucao: 'devolucao' }

  # Associações
  belongs_to :armeiro, class_name: 'Guard'
  belongs_to :guard,   class_name: 'Guard'
  belongs_to :weapon

  # Validações
  validates :movement_type, :date, :time, :ammo_count,
            :ammo_caliber, :magazine_count, presence: true

  validate :weapon_availability
  validate :return_validity
  after_create  :update_weapon_status

  private

  # Validação para checar se a arma já está emprestada
  def weapon_availability
    if weapon.nil?
      errors.add(:weapon, "não selecionada")
    elsif emprestimo? && weapon.borrowed?
      errors.add(:weapon, 'já está emprestada a outro guarda')
    end
  end
  # Validação para checar se a devolução é válida
  def return_validity
    return unless devolucao?
    
    # Pega o último empréstimo para validar a devolução
    last_emprestimo = Movement.emprestimo.where(weapon: weapon, guard: guard).order(:date, :time).last
    if last_emprestimo.nil?
      errors.add(:base, 'Não existe empréstimo desta arma para este guarda')
    end

    # Validar a quantidade de balas e carregadores na devolução
    if (ammo_count > last_emprestimo.ammo_count) || (magazine_count > last_emprestimo.magazine_count)
      errors.add(:base, 'Devolução não pode ter mais munição ou carregadores que o emprestado')
    end

    # Validar se há falta de munição/carregadores
    if (ammo_count < last_emprestimo.ammo_count) || (magazine_count < last_emprestimo.magazine_count)
      errors.add(:justification, 'é obrigatória quando há falta de balas ou carregadores')
    end
  end

  # Atualiza o status da arma após o empréstimo ou devolução
  def update_weapon_status
    weapon.update!(borrowed: emprestimo?)
  end
end
