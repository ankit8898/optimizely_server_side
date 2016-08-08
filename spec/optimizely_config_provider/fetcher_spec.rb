require 'spec_helper'

RSpec.describe OptimizelyConfigProvider::Fetcher do

  it 'has a rest endpoint to fetch config' do
    expect(OptimizelyConfigProvider::Fetcher::API_URL).to eq('https://cdn.optimizely.com/json/5960232316.json')
  end

end
