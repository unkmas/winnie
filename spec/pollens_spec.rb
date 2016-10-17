require 'spec_helper'

describe Pollens do
  let(:pollens) { Pollens.new }

  context '#initialize' do
    it { expect(pollens.instance_variable_get(:@data)).to eq({}) }
  end

  context '#add' do
    context 'when everything is ok' do
      before { pollens.add('10', 'Canola', '15') }

      subject { pollens.instance_variable_get(:@data)['10'] }

      it { expect(subject).to be_a(Pollens::Pollen) }
      it { expect(subject.name).to eq 'Canola' }
      it { expect(subject.sugar_per_mg).to eq 15 }
    end

    context 'when wrong argument passed' do
      it { expect { pollens.add('10', 'Canola', Hash.new) }.to raise_error(ArgumentError) }
    end
  end

  context '#find' do
    before { pollens.add('10', 'Canola', '15') }

    it { expect(pollens.find('10')).to be_a Pollens::Pollen }
    it { expect(pollens.find('11')).to be_nil }
  end
end