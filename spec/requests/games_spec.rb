# spec/requests/todos_spec.rb
require 'rails_helper'

RSpec.describe 'Games API', type: :request do
  # # initialize test data
  # let(:player_one) { create(:player, name: "Eins") }
  # let(:player_two) { create(:player, name: "Zwei") }
  # let(:player_three) { create(:player, name: "Drei") }
  # let(:player_four) { create(:player, name: "Vier") }
  # let!(:game) { create(:game, players: [
  #   player_one,
  #   player_two,
  #   player_three,
  #   player_four
  # ]) }
  # let(:game_id) { game.id }

  # describe 'GET /games/:id' do
  #   before { get "/games/#{game_id}" }

  #   context 'when the record exists' do
  #     fit 'returns the game' do
  #       json = JSON.parse(response.body)
  #       expect(json).not_to be_empty
  #       expect(json['id']).to eq(todo.id)
  #     end

  #     it 'returns status code 200' do
  #       expect(response).to have_http_status(200)
  #     end
  #   end

  #   context 'when the record does not exist' do
  #     let(:game_id) { 100 }

  #     it 'returns status code 404' do
  #       expect(response).to have_http_status(404)
  #     end

  #     it 'returns a not found message' do
  #       expect(response.body).to match(/Couldn't find Game/)
  #     end
  #   end
  # end

  # Creating a new game
  describe 'POST /games' do

    context 'when the request is valid' do
      subject { post '/games' }

      it 'creates a game' do
        expect{subject}.to change{Game.count}.by(1)
      end

      it 'returns status code 201' do
        subject
        expect(response).to have_http_status(201)
      end
    end
  end

  # Adding a ball's score
  describe 'PUT /games/:id' do
    context 'if there are no players' do
      let(:game) { create(:game) }
      before { put "/games/#{game.id}", params: { ball_score: 4 } }
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns an error message message' do
        expect(response.body).to match(/Game has no players/)
      end
    end

    context 'at the start of a game' do
      let(:game) { create(:game) }
      let!(:player_one) { create(:player, name: "Harry Potter", game: game) }
      let!(:player_two) { create(:player, name: "Nick Fury", game: game) }
      before { put "/games/#{game.id}", params: { ball_score: 4 } }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'gives the score to the first player added to the game' do
        expect(player_one.reload.parsed_score).to eq([[4]])
      end
    end
  end

  # Get game's score
  describe 'GET /games/:id' do
    context 'with players' do
      context 'halfway through a game' do
        let(:game) { create(:game) }
        let(:score_one) { "4,5\n2,1\n0,10\n1,1\n" }
        let(:score_two) { "0,10\n10\n5,2\n10" }
        let!(:player_one) { create(:player, name: "Harry Potter", game: game, score: score_one) }
        let!(:player_two) { create(:player, name: "Nick Fury", game: game, score: score_two) }
        before do
          game.update(current_turn: player_two.id, current_frame: 3)
          get "/games/#{game.id}"
        end
        subject { JSON.parse(response.body) }

        it 'returns scores for each player' do
          expect(subject).to include_json(
            scores: {
              player_one.name => { frames: score_one, total: 25 },
              player_two.name => { frames: score_two, total: 54 }
            }
          )
        end
        it 'returns the name of the player whose turn it is' do
          expect(subject).to include_json(current_turn: player_two.name)
        end
        it 'returns current frame in a human (1-10) format (instead of 0-9)' do
          expect(subject).to include_json(current_frame: 4)
        end
        it 'returns the game complete status' do
          expect(subject).to include_json(game_complete: false)
        end
      end

      context 'at the start of a game' do
        let(:game) { create(:game) }
        let!(:player_one) { create(:player, name: "Harry Potter", game: game) }
        let!(:player_two) { create(:player, name: "Nick Fury", game: game) }
        before do
          game.update(current_turn: player_one.id, current_frame: 0)
          get "/games/#{game.id}"
        end
        subject { JSON.parse(response.body) }

        it 'returns empty scores for each player' do
          expect(subject).to include_json(
            scores: {
              player_one.name =>  { frames: '', total: 0 },
              player_two.name =>  { frames: '', total: 0 }
            }
          )
        end
        it 'returns the name of the player whose turn it is' do
          expect(subject).to include_json(current_turn: player_one.name)
        end
        it 'returns current frame in a human (1-10) format (instead of 0-9)' do
          expect(subject).to include_json(current_frame: 1)
        end
        it 'returns the game complete status' do
          expect(subject).to include_json(game_complete: false)
        end
      end
    end
    context 'with no players' do
      let(:game) { create(:game) }
      before { get "/games/#{game.id}" }
      it 'returns a message saying players are needed' do
        expect(response.body).to match(/Game has no players/)
      end
    end
  end
end