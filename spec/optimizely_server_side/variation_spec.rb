require 'spec_helper'

RSpec.describe OptimizelyServerSide::Variation do

  describe '#primary' do

    context 'when no primary is passed' do

      subject { described_class.new }

      it 'defaults to false' do
        expect(subject.primary).to be(false)
      end

    end

    context 'when primary is passed' do

      subject { described_class.new(primary: true) }

      it 'is as per passed' do
        expect(subject.primary).to be(true)
      end

    end
  end


  describe '#content' do

    context 'when no content is passed' do

      subject { described_class.new }

      it 'defaults to nil' do
        expect(subject.instance_variable_get(:@content)).to be_nil
      end

    end

    context 'when content is passed' do

      let(:some_proc) { Proc.new { |n| "Hello #{n} world!"} }

      subject { described_class.new(content: some_proc) }

      it 'is as per passed' do
        expect(subject.instance_variable_get(:@content)).to be(some_proc)
      end

    end
  end

  describe '#key' do

    context 'when no key is passed' do

      subject { described_class.new }

      it 'defaults to nil' do
        expect(subject.instance_variable_get(:@key)).to be_nil
      end
    end

    context 'when key is passed' do


      subject { described_class.new(key: 'ankit_test') }

      it 'is as per passed' do
        expect(subject.instance_variable_get(:@key)).to eq('ankit_test')
      end
    end
  end
end
