class MovementsController < ApplicationController
  before_action :set_movement, only: %i[show edit update destroy]
  after_action :verify_authorized

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
    authorize @movement  # Pundit authorization

    if @movement.save  # Tentando salvar a movimentação
      redirect_to @movement, notice: 'Movimentação registrada com sucesso.'
    else
      render :new  # Se falhar, renderiza a página de novo para o usuário corrigir
    end
  end

  def edit
    authorize @movement
  end

  def update
    authorize @movement
    if @movement.update(movement_params)
      redirect_to @movement, notice: 'Movimentação atualizada com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    authorize @movement
    @movement.destroy
    redirect_to movements_path, notice: 'Movimentação removida.'
  end

  private

    # Método para carregar a movimentação específica
    def set_movement
      @movement = Movement.find(params[:id])
    end

    # Parâmetros permitidos para movimentação
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
end
