class UnitsController < ApplicationController
  # 1) Carrega a unidade antes dos métodos especificados
  before_action :set_unit, only: %i[show edit update destroy]

  # 2) Exige que, em todas as ações, você tenha chamado `authorize`
  after_action :verify_authorized

  # GET /units
  def index
    # 3a) policy_scope traz apenas os registros que o usuário tem permissão de ver
    @units = policy_scope(Unit)
    # 3b) authorize garante que o usuário pode listar unidades
    authorize Unit
  end

  # GET /units/1
  def show
    # aqui já temos @unit graças ao set_unit
    authorize @unit
  end

  # GET /units/new
  def new
    @unit = Unit.new
    authorize @unit
  end

  # POST /units
  def create
    @unit = Unit.new(unit_params)
    authorize @unit              # 🚩 chama Pundit antes de salvar
    if @unit.save
      redirect_to @unit, notice: 'Unidade criada com sucesso.'
    else
      render :new
    end
  end  

  # GET /units/1/edit
  def edit
    authorize @unit
  end

  # PATCH/PUT /units/1
  def update
    authorize @unit

    if @unit.update(unit_params)
      redirect_to @unit, notice: 'Unidade atualizada com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /units/1
  def destroy
    authorize @unit
    @unit.destroy
    redirect_to units_path, notice: 'Unidade removida.'
  end

  private

  # Esse método será chamado pelo before_action
  def set_unit
    @unit = Unit.find(params[:id])
  end

  # Define os parâmetros permitidos vindo do formulário
  def unit_params
    params.require(:unit).permit(:name)
  end
end
