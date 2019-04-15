require 'rails_helper'

RSpec.describe Game, type: :model do
  it { should have_many(:players) }

  describe '#next_turn' do
    let(:game) { create(:game) }
    let!(:player_one) { create(:player, name: "Harry Potter", game: game) }
    let!(:player_two) { create(:player, name: "Nick Fury", game: game) }
    let!(:player_three) { create(:player, name: "Bruce Wayne", game: game) }
    subject { game.next_turn }

    context 'in the middle of a round' do
      before { game.update(current_turn: player_one.id) }

      it 'sets the games current_turn to the next players id' do
        expect{subject}.to change{game.current_turn}.from(player_one.id).to(player_two.id)
      end
    end

    context 'at the end of the round' do
      before { game.update(current_turn: player_three.id) }

      it 'sets the games current_turn back to the first players id' do
        expect{subject}.to change{game.current_turn}.from(player_three.id).to(player_one.id)
      end
      it 'changes to the next frame' do
        expect{subject}.to change{game.current_frame}.by(1)
      end
    end
  end
end
