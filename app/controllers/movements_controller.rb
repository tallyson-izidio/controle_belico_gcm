class MovementsController < ApplicationController
  before_action :set_movement, only: %i[show edit update destroy]
  after_action  :verify_authorized

  def index
    @movements = policy_scope(Movement)
    authorize Movement
  end

  def show
    authorize @movement
  end

  def new
    @movement = Movement.new
    authorize @movement
  end

  def create
    @movement = Movement.new(movement_params)
    authorize @movement
  
    # Validação para empréstimo
    arma = @movement.weapon
    if @movement.emprestimo? && arma&.borrowed?
      redirect_back fallback_location: movements_path, alert: "Esta arma já está emprestada e não pode ser emprestada novamente."
      return
    end
  
    # Validação para devolução
    if @movement.devolucao?
      last_loan = Movement.emprestimo
                          .where(weapon: arma, guard: @movement.guard)
                          .order(:date, :time)
                          .last
  
      if last_loan.nil?
        redirect_back fallback_location: movements_path, alert: "Não existe empréstimo desta arma para este guarda."
        return
      end
  
      # Verifica as diferenças nas quantidades de balas e carregadores
      balas_diff = last_loan.ammo_count - @movement.ammo_count
      carreg_diff = last_loan.magazine_count - @movement.magazine_count
  
      if (balas_diff.positive? || carreg_diff.positive?) && @movement.justification.blank?
        redirect_back fallback_location: movements_path, alert: "Justificativa obrigatória para devolução com falta de balas ou carregadores."
        return
      end
  
      if @movement.ammo_count > last_loan.ammo_count || @movement.magazine_count > last_loan.magazine_count
        redirect_back fallback_location: movements_path, alert: "Devolução não pode ter mais munição ou carregadores do que o emprestado."
        return
      end
    end
  
    # Tenta salvar o movimento
    if @movement.save
      update_weapon_status(@movement)
      redirect_to movements_path, notice: "Movimentação registrada com sucesso."
    else
      # Se falhar, renderiza a página de criação novamente com os erros
      render :new, status: :unprocessable_entity
    end
  end  

  def edit
    authorize @movement
  end

  def update
    authorize @movement

    arma = @movement.weapon

    # Mesma lógica de empréstimo/devolução antes de atualizar
    if movement_params[:movement_type] == "emprestimo" && arma&.borrowed? && !@movement.emprestimo?
      redirect_back fallback_location: movements_path,
                    alert: "Esta arma já está emprestada e não pode ser emprestada novamente."
      return
    end

    if movement_params[:movement_type] == "devolucao" && !@movement.devolucao?
      last_loan = Movement.emprestimo
                        .where(weapon: arma, guard: @movement.guard)
                        .order(:date, :time)
                        .last

      if last_loan.nil? || last_loan.guard != @movement.guard
        redirect_back fallback_location: movements_path,
                      alert: "A arma não pode ser devolvida porque não foi emprestada ou não foi retirada por este guarda."
        return
      end

      balas_diff  = last_loan.ammo_count - movement_params[:ammo_count].to_i
      carreg_diff = last_loan.magazine_count - movement_params[:magazine_count].to_i

      if (balas_diff.positive? || carreg_diff.positive?) && movement_params[:justification].blank?
        redirect_back fallback_location: movements_path,
                      alert: "Justificativa obrigatória para devolução com falta de balas ou carregadores."
        return
      end

      if movement_params[:ammo_count].to_i > last_loan.ammo_count || movement_params[:magazine_count].to_i > last_loan.magazine_count
        redirect_back fallback_location: movements_path,
                      alert: "Devolução não pode ter mais munição ou carregadores do que o emprestado."
        return
      end
    end

    if @movement.update(movement_params)
      update_weapon_status(@movement)
      redirect_to movements_path, notice: "Movimentação atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @movement
    @movement.destroy
    redirect_to movements_path, notice: "Movimentação removida."
  end

  private

  def set_movement
    @movement = Movement.find(params[:id])
  end

  def movement_params
    params.require(:movement).permit(
      :armeiro_id,
      :guard_id,
      :weapon_id,
      :movement_type,
      :date,
      :time,
      :ammo_count,
      :ammo_caliber,
      :magazine_count,
      :justification
    )
  end

  # Atualiza o status da arma após empréstimo ou devolução
  def update_weapon_status(mov)
    mov.weapon&.update!(borrowed: mov.emprestimo?)
  end
end
