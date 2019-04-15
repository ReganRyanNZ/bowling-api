require 'rails_helper'

RSpec.describe Player, type: :model do
  it { should belong_to(:game) }
  it { should validate_presence_of(:name) }

  describe '#parsed_score' do
    let(:player) { create(:player, score: "4,5\n2,1\n0,10\n") }
    it 'returns the players score in an array of frame scores' do
      expect(player.parsed_score).to eq([[4, 5], [2, 1], [0, 10]])
    end
  end

  describe '#total_score' do
    let(:game) { create(:game) }
    let(:player) { create(:player, name: "Harry Potter", game: game, score: score) }

    context 'average player' do
      let(:score) { "4,5\n2,1\n0,10\n1,1\n4,5\n2,1\n0,10\n1,1\n9,1\n6,0\n" }

      it 'correctly adds up the score for a player' do
        expect(player.total_score).to eq(72)
      end
    end

    context 'perfect game' do
      let(:score) { "10\n10\n10\n10\n10\n10\n10\n10\n10\n10,10,10\n" }
      it 'correctly adds up the score for a player' do
        expect(player.total_score).to eq(300)
      end
    end

    context 'one strike' do
      let(:score) { "10\n"}
      it 'correctly adds up the score for a player' do
        expect(player.total_score).to eq(10)
      end
    end
    context 'one strike plus one following ball' do
      let(:score) { "10\n7\n"}
      it 'correctly adds up the score for a player' do
        expect(player.total_score).to eq(24)
      end
    end
    context 'one strike plus two following balls' do
      let(:score) { "10\n7,2\n"}
      it 'correctly adds up the score for a player' do
        expect(player.total_score).to eq(28)
      end
    end
  end

  describe '#turn_complete?' do
    let(:player) { create(:player, score: "4,5\n2,1\n0,10\n10\n4\n") }
    subject { player.turn_complete?(frame) }
    context 'with no balls' do
      let(:frame) { 5 }
      it 'returns false' do
        expect(subject).to be false
      end
    end
    context 'with one ball lower than 10' do
      let(:frame) { 4 }
      it 'returns false' do
        expect(subject).to be false
      end
    end
    context 'with a strike' do
      let(:frame) { 3 }
      it 'returns true' do
        expect(subject).to be true
      end
    end
    context 'with two balls' do
      context 'on a normal frame' do
        let(:frame) { 2 }
        it 'returns true' do
          expect(subject).to be true
        end
      end
      context 'on last frame' do
        let(:frame) { 9 }
        context 'with score less than 10' do
          let(:player) { create(:player, score: "4,5\n2,1\n0,10\n10\n4,2\n4,5\n2,1\n0,10\n10\n4,2\n")}

          it 'returns true' do
            expect(subject).to be true
          end
        end
        context 'with a strike' do
          let(:player) { create(:player, score: "4,5\n2,1\n0,10\n10\n4,2\n4,5\n2,1\n0,10\n10\n10,6\n")}

          it 'returns false' do
            expect(subject).to be false
          end
        end
        context 'with a spare' do
          let(:player) { create(:player, score: "4,5\n2,1\n0,10\n10\n4,2\n4,5\n2,1\n0,10\n10\n6,4\n")}

          it 'returns false' do
            expect(subject).to be false
          end
        end
      end
    end
    context 'with three balls on last frame' do
      let(:player) { create(:player, score: "4,5\n2,1\n0,10\n10\n4,2\n4,5\n2,1\n0,10\n10\n6,4,7\n")}
      let(:frame) { 9 }

      it 'returns true' do
        expect(subject).to be true
      end
    end
  end
end
