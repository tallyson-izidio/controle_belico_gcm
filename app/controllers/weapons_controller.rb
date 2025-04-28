class WeaponsController < ApplicationController
  before_action :set_weapon, only: %i[show edit update destroy]
  after_action  :verify_authorized

  def index
    @weapons = policy_scope(Weapon)
    authorize Weapon
  end

  def show
    authorize @weapon
  end

  def new
    @weapon = Weapon.new
    authorize @weapon
  end

  def create
    @weapon = Weapon.new(weapon_params)
    authorize @weapon
    if @weapon.save
      redirect_to @weapon, notice: 'Arma cadastrada com sucesso.'
    else
      render :new
    end
  end

  def edit
    authorize @weapon
  end

  def update
    authorize @weapon
    if @weapon.update(weapon_params)
      redirect_to @weapon, notice: 'Arma atualizada com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    authorize @weapon
    @weapon.destroy
    redirect_to weapons_path, notice: 'Arma removida.'
  end

  private
    def set_weapon
      @weapon = Weapon.find(params[:id])
    end

    def weapon_params
      params.require(:weapon).permit(:model, :registration, :borrowed)
    end
end