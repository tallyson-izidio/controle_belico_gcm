class GuardsController < ApplicationController
  before_action :set_guard, only: %i[show edit update destroy]
  after_action  :verify_authorized

  def index
    @guards = policy_scope(Guard)
    authorize Guard
  end

  def show
    authorize @guard
  end

  def new
    @guard = Guard.new
    authorize @guard
  end

  def create
    @guard = Guard.new(guard_params)
    authorize @guard
    if @guard.save
      redirect_to @guard, notice: 'Guarda criado com sucesso.'
    else
      render :new
    end
  end

  def edit
    authorize @guard
  end

  def update
    authorize @guard
    if @guard.update(guard_params)
      redirect_to @guard, notice: 'Guarda atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    authorize @guard
    @guard.destroy
    redirect_to guards_path, notice: 'Guarda removido.'
  end

  private
    def set_guard
      @guard = Guard.find(params[:id])
    end

    def guard_params
      params.require(:guard).permit(:full_name, :matricula, :porte_numero, :team_id)
    end
end