require 'spec_helper'

RSpec.describe OptimizelyConfigProvider::Variation do

  subject { OptimizelyConfigProvider::Variation.new(variation_key = 'variation_key_a') }


  describe '#compute' do


    before do

      subject.variation_one('variation_key_a') do
        'experience a'
      end

      subject.variation_two('variation_key_b') do
        'experience b'
      end

    end

    it 'should result variation b' do
      expect(subject.compute).to eq('experience a')
    end
  end


  ['variation_one','variation_two','variation_three','variation_default'].each do |variation|

    describe "#{variation}" do

      context 'it accepts regular strings' do

        it do
          expect(subject.send(variation,'foo') do
                   'Hello!'
          end).to eq('Hello!')
        end

      end


      context 'it accepts a block' do

        let(:some_block) do
          -> { 'something'}
        end

        it do
          expect(subject.send(variation,'foo') do
                   some_block
          end).to eq(some_block)
        end

      end

    end


    describe '#hsh' do

      context 'key accepts regular strings' do

        let(:string) { 'I am a variation' }

        before do
          subject.variation_one('foo') do
            string
          end
        end

        it 'has value as string' do
          expect(subject.hsh).to eq({'foo' => string})
        end

      end


      context 'key accepts blocks / proc' do

        let(:proc) { Proc.new {|n| n*2 } }

        before do
          subject.variation_one('foo') do
            proc
          end
        end

        it 'has value as proc' do
          expect(subject.hsh).to eq({'foo' => proc})
        end

      end

      context 'key accepts string, html or blocks / proc' do

        let(:proc) { Proc.new {|n| n*2 } }
        let(:html) do
          '<!DOCTYPE html>
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
        end
        let(:string) { 'Hello!'}

        before do
          subject.variation_one('foo') do
            proc
          end

          subject.variation_two('foo_two') do
            html
          end

          subject.variation_three('foo_three') do
            string
          end
        end

        it 'has value as proc' do
          expect(subject.hsh).to eq({'foo' => proc, 'foo_two' => html, 'foo_three' => string})
        end

      end
    end
  end
end
