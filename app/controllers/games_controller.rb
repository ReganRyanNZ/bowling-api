require 'csv'

class GamesController < ApplicationController
  before_action :set_game, only: [:total_score, :add_score]

  def create
    @game = Game.new()
    if @game.save
      render json: @game.id, status: :created
    else
      render json: @game, status: 500
    end
  end

  def add_score
    @players = @game.players
    return render json: "Error: Game has no players", status: 422 if(@players.empty?)

    @game.current_turn ||= @players.first.id

    @player = Player.find(@game.current_turn)
    player_score = CSV.parse(@player.score)
    player_score[@game.current_frame] ||= []
    player_score[@game.current_frame] << params[:ball_score].to_i
    @player.update!(score: player_score.map(&:to_csv).join)
    render json: {}, status: :ok
  end

  def total_score
    render json: @game.score, status: :ok
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

end
