class TeamsController < ApplicationController
  before_action :set_team, only: %i[show edit update destroy]
  after_action  :verify_authorized

  def index
    @teams = policy_scope(Team)
    authorize Team
  end

  def show
    authorize @team
  end

  def new
    @team = Team.new
    authorize @team
  end

  def create
    @team = Team.new(team_params)
    authorize @team
    if @team.save
      redirect_to @team, notice: 'Equipe criada com sucesso.'
    else
      render :new
    end
  end

  def edit
    authorize @team
  end

  def update
    authorize @team
    if @team.update(team_params)
      redirect_to @team, notice: 'Equipe atualizada com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    authorize @team
    @team.destroy
    redirect_to teams_path, notice: 'Equipe removida.'
  end

  private
    def set_team
      @team = Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit(:name, :unit_id)
    end
end