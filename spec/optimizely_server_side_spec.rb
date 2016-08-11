require 'spec_helper'

RSpec.describe OptimizelyServerSide do

  describe "#configure" do

    context 'when config is set in regular way' do

      before do
        OptimizelyServerSide.configure do |config|
          config.config_endpoint = 'https://cdn.optimizely.com/json/5960232316.json'
          config.cache_expiry    = 12
        end
      end

      it 'has config_endpoint' do
        expect(OptimizelyServerSide.configuration.config_endpoint).to eq('https://cdn.optimizely.com/json/5960232316.json')
      end

      it 'has cache_expiry' do
        expect(OptimizelyServerSide.configuration.cache_expiry).to eq(12)
      end

      it 'has no visitor_id' do
        expect(OptimizelyServerSide.configuration.visitor_id).to be_nil
      end
    end


    context 'when config is set in between' do

      before do
        OptimizelyServerSide.configure do |config|
          config.config_endpoint = 'https://cdn.optimizely.com/json/5960232316.json'
          config.cache_expiry    = 12
        end
      end

      it 'has config_endpoint' do
        OptimizelyServerSide.configure do |config|
          config.visitor_id = '1234abcdef'
        end

        expect(OptimizelyServerSide.configuration.config_endpoint).to eq('https://cdn.optimizely.com/json/5960232316.json')
      end

      it 'has cache_expiry' do
        expect(OptimizelyServerSide.configuration.cache_expiry).to eq(12)
      end

      it 'has no visitor_id' do
        expect(OptimizelyServerSide.configuration.visitor_id).to eq('1234abcdef')
      end
    end

  end
end

def foo
  experiment(EXPERIMENT_KEY) do |config|

    config.variation_one(VARIATION_ONE_KEY) do
      # Code for experience one. it can be html or a ruby code
    end

    config.variation_two(VARIATION_TWO_KEY) do
      # Code for experience two. it can be html or a ruby code
    end

    config.variation_default(variation_default_KEY) do
      # Code for experience default. it can be html or a ruby code
    end

  end
end
