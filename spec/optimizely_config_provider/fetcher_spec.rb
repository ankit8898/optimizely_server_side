require 'spec_helper'

RSpec.describe OptimizelyConfigProvider::Fetcher do

  describe 'API url' do

    it 'has a rest endpoint to fetch config' do
      expect(OptimizelyConfigProvider::Fetcher::API_URL).to eq('https://cdn.optimizely.com/json/5960232316.json')
    end

  end


  describe '#fetch' do

    before do
      stub_request(:get, "https://cdn.optimizely.com/json/5960232316.json")
      .to_return(body: '{"experiments": [{"status": "running"}]}',status: 200)
    end

    it 'should fetch the config' do
      expect(described_class.fetch).to eq('{"experiments": [{"status": "running"}]}')
    end


    it 'should return parsed config response' do
      expect(described_class.parsed_response).to eq({experiments: [{status: "running"}]})
    end

  end

end
