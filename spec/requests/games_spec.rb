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

  # # Test suite for PUT /todos/:id
  # describe 'PUT /todos/:id' do
  #   let(:valid_attributes) { { title: 'Shopping' } }

  #   context 'when the record exists' do
  #     before { put "/todos/#{todo_id}", params: valid_attributes }

  #     it 'updates the record' do
  #       expect(response.body).to be_empty
  #     end

  #     it 'returns status code 204' do
  #       expect(response).to have_http_status(204)
  #     end
  #   end
  # end

  # # Test suite for DELETE /todos/:id
  # describe 'DELETE /todos/:id' do
  #   before { delete "/todos/#{todo_id}" }

  #   it 'returns status code 204' do
  #     expect(response).to have_http_status(204)
  #   end
  # end
end