require 'spec_helper'

RSpec.describe OptimizelyServerSide::Support do

  class MyEventDispatcher

    def dispatch_event(url,params)
      puts "Do nothing with #{url} and #{params}"
    end
  end
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


  describe '#experiment' do

    subject { FakeKlass.new }

    context 'everything is good' do


      before do
        allow(subject).to receive(:optimizely_sdk_project_instance).and_return('variation_one')
      end

      it { expect(subject.some_klass_method).to eq('Experience one')}
    end


    context 'when a fatal error has happened' do

      let(:response) do
        '{
            "experiments": [],
            "version": "1",
            "audiences": [],
            "dimensions": [],
            "groups": [],
            "projectId": "5960232316",
            "accountId": "5955320306",
            "events": [],
            "revision": "30"
          }'
      end

      before do
        stub_request(:get, "https://cdn.optimizely.com/json/5960232316.json")
        .to_return(body: response, status: 500)
      end


      it { expect(subject.some_klass_method).to be_nil }
    end
  end
end
