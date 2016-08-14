require 'spec_helper'

RSpec.describe OptimizelyServerSide::Experiment do

  subject { OptimizelyServerSide::Experiment.new(variation_key = 'variation_key_a') }


  describe '#compute' do

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
        expect(subject.compute).to eq('experience a')
      end

    end


    context 'when variation_key is not present' do
      subject { OptimizelyServerSide::Experiment.new(variation_key = '') }

      it 'should be nil' do
        expect(subject.compute).to be_nil
      end
    end


  end

  describe '#variation_one' do

    let(:blk) { Proc.new { 'Hello!'} }

    it 'returns a block passed' do
      expect(subject.variation_one('foo', &blk)).to eq(blk)
    end
  end


  describe '#variation_two' do

    let(:blk) { -> {OpenStruct.new } }

    it 'returns a block passed' do
      expect(subject.variation_two('foo', &blk)).to eq(blk)
    end
  end

  describe '#variation_three' do

    let(:blk) { Proc.new { 'Hello!'} }

    it 'returns a block passed' do
      expect(subject.variation_three('foo', &blk)).to eq(blk)
    end
  end

  describe '#store' do

    context 'key accepts regular strings' do

      let(:string_lambda) { -> {'I am a variation' } }

      before do
        subject.variation_one('foo', &string_lambda)
      end

      it 'has value as string' do
        expect(subject.instance_variable_get(:@store)).to eq({'foo' => string_lambda})
      end

    end


    context 'key accepts blocks / proc' do

      let(:some_method) { Proc.new {|n| n*2 } }

      before do
        subject.variation_one('foo', &some_method)
      end

      it 'has value as proc' do
        expect(subject.instance_variable_get(:@store)).to eq({'foo' => some_method})
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

      it 'has value as proc' do
        expect(subject.instance_variable_get(:@store)).to eq({'foo' => some_method, 'foo_two' => some_html_block, 'foo_three' => string_blk})
      end

    end
  end
end
