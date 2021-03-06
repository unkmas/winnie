require 'spec_helper'

describe Winnie do
  let(:reader) { double('reader') }
  let(:winnie) { Winnie.new('path', 'path') }
  before { allow(Reader).to receive(:new).and_return(reader) }

  context '#initialize' do
    it 'should call read' do
      expect(reader).to receive(:read)
      winnie
    end
  end

  context '#values' do
    let(:bee_stats) { double('bee_stats', best_sugar_pollen: '1', most_popular_pollen: '2') }

    before do
      allow(bee_stats).to receive(:best).with(:days, :sugar_total).and_return(double('total', key: '3'))
      allow(bee_stats).to receive(:worst).with(:days, :sugar_total).and_return(double('total', key: '4'))

      allow(bee_stats).to receive(:get_stats).with(:bee).and_return([
        double('total', sugar_total: 10, records_total: 1, key: '5'),
        double('total', sugar_total: 10, records_total: 10, key: '6')
      ])

      allow(bee_stats).to receive(:get_stats).with(:days)
    end

    before { allow(reader).to receive(:read).and_return(bee_stats) }

    subject { winnie.send(:values) }

    it { expect(subject[:best_sugar_pollen]).to eq '1' }
    it { expect(subject[:most_popular_pollen]).to eq '2' }
    it { expect(subject[:best_day]).to eq '3' }
    it { expect(subject[:worst_day]).to eq '4' }
    it { expect(subject[:best_bee]).to eq '5' }
    it { expect(subject[:worst_bee]).to eq '6' }
  end

  context '#output' do
    before { allow(reader).to receive(:read).and_return(double('bee_stats')) }
    before { allow(winnie).to receive(:values).and_return(double('values')) }

    it 'should render plaintext if format is plain' do
      expect(Formatter::PlainText).to receive(:format)
      winnie.output(:plain)
    end

    it 'should render pdf if format is pdf' do
      expect(Formatter::PDF).to receive(:format)
      winnie.output(:pdf)
    end

    it 'should raise error if unsupported format given' do
      expect { winnie.output(:jpg) }.to raise_error(ArgumentError)
    end
  end
end