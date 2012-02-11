# encoding: utf-8

require File.expand_path('../../spec_helper', __FILE__)

class Myaso::TokyoCabinet
  describe Prefixes do
    let(:tmpdir) { Dir.mktmpdir }
    let(:myaso) { Myaso::TokyoCabinet.new(tmpdir, :manage) }

    subject { myaso.prefixes }

    before { populate_tokyo_cabinet! myaso }

    after do
      myaso.close!
      FileUtils.remove_entry_secure tmpdir
    end

    describe '#get' do
      it 'should fetch a prefix' do
        subject.find(1).must_equal({'prefix' => 'sub'})
      end

      it 'should fetch a prefix in UTF-8' do
        subject.find(2).must_equal({'prefix' => 'bi'})
      end

      it 'should return nil when prefix is absent' do
        subject.find(3).must_be_nil
      end
    end

    describe '#set' do
      let(:prefix) { { 'prefix' => 'foo' } }

      it 'should set an empty prefix' do
        subject.find(3).must_be_nil
        subject.set(3, prefix)
        subject.find(3).must_equal prefix
      end

      it 'should replace an existent prefix' do
        new_prefix = { 'prefix' => 'bar' }

        subject.find(3).must_be_nil
        subject.set(3, prefix)
        subject.find(3).must_equal prefix
        subject.set(3, new_prefix)
        subject.find(3).must_equal new_prefix
      end
    end

    describe '#delete' do
      let(:prefix) { { 'prefix' => 'foo' } }

      it 'should remove an existent prefix' do
        subject.find(3).must_be_nil
        subject.set(3, prefix)
        subject.find(3).must_equal prefix
        subject.delete(3).must_equal true
        subject.find(3).must_be_nil
      end

      it 'should not remove an existent prefix' do
        subject.find(3).must_be_nil
        subject.delete(3).must_equal false
      end
    end
  end
end
