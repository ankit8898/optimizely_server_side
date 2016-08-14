require 'spec_helper'

RSpec.describe OptimizelyServerSide::Cache do

  describe 'singleton' do

    it 'should be a singleton instance' do
      expect(described_class.instance).to equal(described_class.instance)
    end
  end


  describe '#cache_store_instance' do

    it 'should be a instance of Activesupport memory store' do
      expect(described_class.instance.cache_store_instance).to be_kind_of(ActiveSupport::Cache::MemoryStore)
    end

  end

  describe '.fetch' do

    before do
      stub_request(:get, "https://cdn.optimizely.com/json/5960232316.json")
      .to_return(body: '{"experiments": [{"status": "running"}]}',status: 200)
    end

    it 'should return the config from API and cache it' do
      expect(
        described_class.fetch('key') do
          JSON.parse(OptimizelyServerSide::DatafileFetcher.datafile.content, symbolize_names: true)
        end
      ).to eq(
        {
          experiments: [{status: "running"}]
        }
      )
    end
  end
end
