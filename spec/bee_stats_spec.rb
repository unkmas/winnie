require 'spec_helper'

describe BeeStats do

  let(:bee_stats) { BeeStats.new }

  context '#initialize' do
    it { expect(bee_stats.pollens).to  be_a Pollens }
    it { expect(bee_stats.workdays).to be_a Workdays }
  end

  context 'when have a look at stats' do
    before do
      bee_stats.pollens.add('1', 'Rose', 5)
      bee_stats.pollens.add('2', 'Tulip', 5)
      bee_stats.workdays.add('1', '2010-01-01', '1', 10, 10)
      bee_stats.workdays.add('1', '2010-01-01', '1', 10, 10)
      bee_stats.workdays.add('2', '2010-01-02', '2', 10, 10)
    end

    context '#best_sugar_pollen' do
      it { expect(bee_stats.best_sugar_pollen).to eq 'Rose'}
    end

    context '#most_popuplar_pollen' do
      it { expect(bee_stats.most_popular_pollen).to eq 'Rose' }
    end

    context '#best' do
      it { expect(bee_stats.best(:days, :sugar_total).key).to eq '2010-01-01' }
      it { expect(bee_stats.best(:bee,  :sugar_total).key).to eq '1' }
      it { expect(bee_stats.best(:pollen, :sugar_total).key).to eq '1' }
    end

    context '#worst' do
      it { expect(bee_stats.worst(:days, :sugar_total).key).to eq '2010-01-02' }
      it { expect(bee_stats.worst(:bee,  :sugar_total).key).to eq '2' }
      it { expect(bee_stats.worst(:pollen, :sugar_total).key).to eq '2' }
    end

    context '#get_stats' do
      context 'when there is no such stat' do
        it { expect { bee_stats.get_stats(:foo) }.to raise_error(ArgumentError) }
      end
    end
  end
end