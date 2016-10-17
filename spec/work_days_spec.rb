require 'spec_helper'

describe Workdays do
  let(:workdays) { Workdays.new }

  context '#initialize' do
    it { expect(workdays.instance_variable_get(:@data)).to eq([]) }
  end

  context '#add' do
    context 'when everything is ok' do
      before { workdays.add('10', '2011-10-11', '1', '10', '15') }

      subject { workdays.instance_variable_get(:@data).first }

      it { expect(subject).to be_a(Workdays::Workday) }

      it { expect(subject.bee_id).to          eq '10' }
      it { expect(subject.day).to             eq '2011-10-11' }
      it { expect(subject.pollen_id).to       eq '1' }
      it { expect(subject.mg_harvested).to    eq 10 }
      it { expect(subject.sugar_harvested).to eq 15 }
    end

    context 'when wrong argument passed' do
      it { expect { workdays.add('10', '2011-10-11', '1', Hash.new, '15') }.to raise_error(ArgumentError) }
      it { expect { workdays.add('10', '2011-10-11', '1', '15', Hash.new) }.to raise_error(ArgumentError) }
    end
  end

  context 'when have a look at totals' do
    before do
      workdays.add('1', '2011-10-11', '1', '10', '1')
      workdays.add('1', '2011-10-11', '1', '11', '2')
      workdays.add('2', '2011-10-11', '2', '12', '3')
      workdays.add('3', '2011-11-11', '2', '13', '4')
      workdays.add('3', '2011-11-11', '3', '14', '5')
    end

    shared_examples 'totals' do |method_name, test_cases|
      subject { workdays.send(method_name) }

      it { expect(subject).to be_an Array }
      it { expect(subject.first).to be_a Workdays::Totals }

      test_cases.each do |test_case|
        it 'should include value' do
          workday = subject.select {|workday| workday.key == test_case[0] }.first
          expect(workday.mg_total).to eq test_case[1]
          expect(workday.sugar_total).to eq test_case[2]
        end
      end
    end

    it_behaves_like 'totals', 'pollen_totals', [
      ['1', 21, 3],
      ['2', 25, 7],
      ['3', 14, 5]
    ]

    it_behaves_like 'totals', 'bee_totals', [
      ['1', 21, 3],
      ['2', 12, 3],
      ['3', 27, 9]
    ]

    it_behaves_like 'totals', 'days_totals', [
      ['2011-10-11', 33, 6],
      ['2011-11-11', 27, 9]
    ]
  end
end