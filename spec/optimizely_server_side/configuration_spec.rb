require 'spec_helper'

RSpec.describe OptimizelyServerSide::Configuration do

  subject { OptimizelyServerSide::Configuration.new }

  describe '#config_endpoint' do

    it 'has a default value of http://foo.com' do
      expect(subject.config_endpoint).to eq('http://foo.com')
    end

  end

  describe '#user_attributes' do

    it 'defaults to {}' do
      expect(subject.user_attributes).to eq({})
    end
  end


  describe '#event_dispatcher' do

    it 'defaults to nil' do
      expect(subject.event_dispatcher).to be_nil
    end

  end
end
