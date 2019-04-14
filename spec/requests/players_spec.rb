require 'rails_helper'

RSpec.describe 'Players API', type: :request do

  let(:game) { create(:game) }

  describe 'POST /games/:id/players' do
    context 'when the request is valid' do
      subject { post "/games/#{game.id}/players", params: { player: { name: 'Harry Potter' } } }

      it 'creates a player' do
        expect{subject}.to change{Player.count}.by(1)
      end
      it 'creates a player with correct attributes' do
        subject
        expect(JSON.parse(response.body)['name']).to eq('Harry Potter')
      end
      it 'returns status code 201' do
        subject
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "/games/#{game.id}/players", params: { player: { name: '' } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end
end