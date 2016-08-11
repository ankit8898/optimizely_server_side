require 'spec_helper'

RSpec.describe OptimizelyServerSide::Support do

  class FakeKlass

    include OptimizelyServerSide::Support


    def some_klass_method

      experiment('foo_experiment_key') do |config|

        config.variation_one('variation_one') do
          'Experience one'
        end

        config.variation_two('variation_two') do
          'Experience two'
        end

      end
    end
  end


  context '#experiment' do

    subject { FakeKlass.new }

    before do
      allow(subject).to receive(:optimizely_sdk_project_instance).and_return('variation_one')
    end

    it { expect(subject.some_klass_method).to eq('Experience one')}
  end
end
