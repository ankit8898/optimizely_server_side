require 'spec_helper'

RSpec.describe OptimizelyConfigProvider::Cache do

  describe 'singleton' do

    it 'should be a singleton instance' do
      expect(described_class.instance).to equal(described_class.instance)
    end
  end

  describe '.fetch' do

    before do
      stub_request(:get, "https://cdn.optimizely.com/json/5960232316.json")
      .to_return(body: '{"experiments": [{"status": "running"}]}',status: 200)
    end

    it 'should return the config from API and cache it' do
      expect(described_class.fetch).to eq({experiments: [{status: "running"}]})
    end
  end
end
