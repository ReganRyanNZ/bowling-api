class PlayersController < ApplicationController
  before_action :set_game, only: [:total_score, :add_score]

  def create
    if params.dig(:player, :name).nil?
      return render json: "Error: Player name not found. Syntax is games/:game_id/players?player[name]=example", status: 400
    end
    @game = Game.find(params[:game_id])
    @player = @game.players.create!(player_params)
    render json: @player, status: :created
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end

end
