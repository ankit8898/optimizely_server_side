require 'spec_helper'

RSpec.describe OptimizelyServerSide::Experiment do

  subject { OptimizelyServerSide::Experiment.new('foo', variation_key = 'variation_key_a') }


  describe '#applicable_variation' do

    before do

      subject.variation_one('variation_key_a') do
        'experience a'
      end

      subject.variation_two('variation_key_b') do
        'experience b'
      end

    end

    context 'when variation_key is present' do

      it 'should result variation b' do
        expect(subject.applicable_variation).to eq('experience a')
      end

    end


    context 'when variation_key is not present' do
      subject { OptimizelyServerSide::Experiment.new(experiment = 'foo', variation_key = '') }

      it 'should be nil' do
        expect(subject.applicable_variation).to be_nil
      end
    end


    context 'when the variation are named anything else' do

      subject { OptimizelyServerSide::Experiment.new(experiment = 'foo', variation_key = 'foobar') }

      let(:some_method) { Proc.new {|n| n*2 } }

      let(:some_html_block) do
        -> { '<h1>Foo</h1>' }
      end

      let(:string_blk) { -> { 'Hello!'} }


      before do
        subject.variation_bottom_lead_form('foo', &some_method)

        subject.variation_middle_lead_form('foo_two', primary: true, &some_html_block)

        subject.variation_pathetic_form('foobar', &string_blk)
      end

      it { expect(subject.applicable_variation).to eq('Hello!') }
    end


  end

  describe '#variation_one' do

    let(:blk) { Proc.new { 'Hello!'} }

    before do
      @variation_instance = subject.variation_one('foo', &blk)
    end

    it 'returns a variation instance passed' do
      expect(@variation_instance).to be_kind_of(OptimizelyServerSide::Variation)
    end

    it 'returns a key of foo' do
      expect(@variation_instance.key).to eq('foo')
    end

    it 'returns a content with blk ' do
      expect(@variation_instance.instance_variable_get(:@content)).to eq(blk)
    end

    it 'is not primary' do
      expect(@variation_instance.primary).to be(false)
    end

  end


  describe '#variation_two' do

    let(:blk) { -> {OpenStruct.new } }

    before do
      @variation_instance = subject.variation_two('foo', &blk)
    end

    it 'returns a variation instance passed' do
      expect(@variation_instance).to be_kind_of(OptimizelyServerSide::Variation)
    end

    it 'returns a key of foo' do
      expect(@variation_instance.key).to eq('foo')
    end

    it 'returns a content with blk ' do
      expect(@variation_instance.instance_variable_get(:@content)).to eq(blk)
    end

    it 'is not primary' do
      expect(@variation_instance.primary).to be(false)
    end
  end

  describe '#variation_three' do

    let(:blk) { Proc.new { 'Hello!'} }

    before do
      @variation_instance = subject.variation_three('foo', &blk)
    end

    it 'returns a variation instance passed' do
      expect(@variation_instance).to be_kind_of(OptimizelyServerSide::Variation)
    end

    it 'returns a key of foo' do
      expect(@variation_instance.key).to eq('foo')
    end

    it 'returns a content with blk ' do
      expect(@variation_instance.instance_variable_get(:@content)).to eq(blk)
    end

    it 'is not primary' do
      expect(@variation_instance.primary).to be(false)
    end
  end

  describe '#variation_default' do

    let(:blk) { -> {'<div><h1>Hello</h1></div>'} }

    before do
      @variation_instance = subject.variation_default('foo', primary: true, &blk)
    end

    it 'returns a variation instance passed' do
      expect(@variation_instance).to be_kind_of(OptimizelyServerSide::Variation)
    end

    it 'returns a key of foo' do
      expect(@variation_instance.key).to eq('foo')
    end

    it 'returns a content with blk ' do
      expect(@variation_instance.instance_variable_get(:@content)).to eq(blk)
    end

    it 'is primary' do
      expect(@variation_instance.primary).to be(true)
    end
  end


  describe '#variation_bottom_lead_form' do

    let(:blk) { -> {'<div><h1>Hello</h1></div>'} }

    before do
      @variation_instance = subject.variation_bottom_lead_form('foo', primary: true, &blk)
    end

    it 'returns a variation instance passed' do
      expect(@variation_instance).to be_kind_of(OptimizelyServerSide::Variation)
    end

    it 'returns a key of foo' do
      expect(@variation_instance.key).to eq('foo')
    end

    it 'returns a content with blk ' do
      expect(@variation_instance.instance_variable_get(:@content)).to eq(blk)
    end

    it 'is primary' do
      expect(@variation_instance.primary).to be(true)
    end
  end

  describe '#variations' do

    context 'key accepts regular strings' do

      let(:string_lambda) { -> {'I am a variation' } }

      before do
        subject.variation_one('foo', &string_lambda)
      end

      it 'holds collection of variations' do
        expect(subject.instance_variable_get(:@variations).count).to eq(1)
      end

      it 'is a type of Variation' do
        expect(subject.instance_variable_get(:@variations)[0]).to be_kind_of(OptimizelyServerSide::Variation)
      end

      it 'is having the block content' do
        expect(subject.instance_variable_get(:@variations)[0].call).to eq('I am a variation')
      end

    end


    context 'key accepts blocks / proc' do

      let(:some_method) { Proc.new {|n| n*2 } }

      before do
        subject.variation_one('foo', &some_method)
      end

      it 'has content as proc' do
        expect(subject.instance_variable_get(:@variations)[0].instance_variable_get(:@content)).to eq(some_method)
      end

      it 'has key' do
        expect(subject.instance_variable_get(:@variations)[0].key).to eq('foo')
      end

    end

    context 'key accepts string, html or blocks / proc' do

      let(:some_method) { Proc.new {|n| n*2 } }

      let(:some_html_block) do
        -> {'<!DOCTYPE html>
            <html>
            <head>
            <title>Page Title</title>
            </head>
            <body>

            <h1>This is a Heading</h1>
            <p>This is a paragraph.</p>

            </body>
            </html>
          '
            }
      end

      let(:string_blk) { -> { 'Hello!'} }

      before do
        subject.variation_one('foo', &some_method)

        subject.variation_two('foo_two', &some_html_block)

        subject.variation_three('foo_three', &string_blk)
      end

      it 'has all variations' do
        expect(subject.instance_variable_get(:@variations).count).to eq(3)
      end

      it 'has all variations of class Variation' do
        expect(subject.instance_variable_get(:@variations)).to all(be_an(OptimizelyServerSide::Variation))
      end

    end
  end


  describe '#primary_variation' do

    let(:some_method) { Proc.new {|n| n*2 } }

    let(:some_html_block) do
      -> { '<h1>Foo</h1>' }
    end

    let(:string_blk) { -> { 'Hello!'} }


    context 'when nothing is marked as primary' do

      before do
        subject.variation_one('foo', &some_method)

        subject.variation_two('foo_two', &some_html_block)

        subject.variation_three('foo_three', &string_blk)
      end

      it { expect(subject.primary_variation).to be_nil }
    end

    context 'when one is marked as primary' do

      before do
        subject.variation_one('foo', &some_method)

        subject.variation_two('foo_two',primary: true, &some_html_block)

        subject.variation_three('foo_three', &string_blk)
      end

      it { expect(subject.primary_variation).not_to be_nil }

      it { expect(subject.primary_variation.call).to eq('<h1>Foo</h1>') }
    end


    context 'when multiple are marked as primary' do

      before do
        subject.variation_one('foo', &some_method)

        subject.variation_three('foo_two', primary: true, &some_html_block)

        subject.variation_two('foo_three',primary: true, &string_blk)
      end

      it { expect(subject.primary_variation).not_to be_nil }

      it { expect(subject.primary_variation.call).to eq('<h1>Foo</h1>') }
    end


    context 'when test are having own variation names' do

      before do
        subject.variation_bottom_lead_form('foo', &some_method)

        subject.variation_middle_lead_form('foo_two', primary: true, &some_html_block)

        subject.variation_pathetic_form('foo_three',&string_blk)
      end

      it { expect(subject.primary_variation).not_to be_nil }

      it { expect(subject.primary_variation.call).to eq('<h1>Foo</h1>') }
    end

  end


  describe '#omniture_tag' do

    context 'when experiment and selected variation is present' do

      it 'should have omniture_tag' do
        expect(subject.omniture_tag(evar: '11')).to eq("<input type='hidden' data-optimizely=foo:variation_key_a data-optimizely-evar=11></input>")
      end

    end

    context 'when experiment is not having selected variation' do

      subject { OptimizelyServerSide::Experiment.new('bar',nil) }

      it 'should have omniture_tag' do
        expect(subject.omniture_tag(evar: '11')).to be_nil
      end

    end
  end
end
