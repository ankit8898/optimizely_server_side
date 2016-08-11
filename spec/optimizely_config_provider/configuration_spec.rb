require 'spec_helper'

RSpec.describe OptimizelyConfigProvider::Configuration do

  subject { OptimizelyConfigProvider::Configuration.new }

  describe '#config_endpoint' do

    it 'has a default value of http://foo.com' do
      expect(subject.config_endpoint).to eq('http://foo.com')
    end

  end

  describe '#visitor_id' do

    it 'defaults to nil' do
      expect(subject.visitor_id).to be_nil
    end
  end
end
