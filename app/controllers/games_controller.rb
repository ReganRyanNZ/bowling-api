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
    players = @game.players.map(&:id)
    return render json: "Error: Game has no players", status: 422 if(players.empty?)

    player = Player.find(@game.current_turn)
    player.add_score(frame: @game.current_frame, new_score: params[:ball_score].to_i)
    @game.next_turn if player.turn_complete?(@game.current_frame)
    render json: {}, status: :ok
  end

  def total_score
    return render json: "Error: Game has no players", status: 422 if(@game.players.empty?)
    render json: @game.score, status: :ok
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

end
