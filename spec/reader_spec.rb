require 'spec_helper'

describe Reader do
  let(:reader) do
    Reader.new(
      File.join(File.dirname(__FILE__), 'data/pollens.csv'),
      File.join(File.dirname(__FILE__), 'data/harvest.csv')
    )
  end

  context '#initialize' do
    it { expect(reader.pollen_path).to  end_with('data/pollens.csv') }
    it { expect(reader.harvest_path).to end_with('data/harvest.csv') }
  end

  context '#read' do
    subject { reader.read }

    it { expect(subject).to be_a BeeStats }

    it { expect(subject.pollens).to be_a Pollens }
    it { expect(subject.pollens.find('1').name).to eq 'Canola' }

    it { expect(subject.workdays).to be_a Workdays }
    it { expect(subject.workdays.instance_variable_get(:@data).length).to eq 8 }
  end
end