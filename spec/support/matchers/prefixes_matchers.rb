# encoding: utf-8

class MiniTest::Unit::TestCase
  def self.should_behave_like_a_prefixes!
    describe '#get' do
      it 'should fetch a prefix' do
        subject.find(1).must_equal Myaso::Prefix.new(1, 'sub')
      end

      it 'should fetch a prefix in UTF-8' do
        subject.find(2).must_equal Myaso::Prefix.new(2, 'би')
      end

      it 'should return nil when prefix is absent' do
        subject.find(3).must_be_nil
      end
    end

    describe '#set' do
      let(:prefix) { Myaso::Prefix.new(3, 'foo') }

      it 'should set an empty prefix' do
        subject.find(3).must_be_nil
        subject.set(prefix, 3)
        subject.find(3).must_equal prefix
      end

      it 'should replace an existent prefix' do
        new_prefix = Myaso::Prefix.new(3, 'bar')

        subject.find(3).must_be_nil
        subject.set(prefix, 3)
        subject.find(3).must_equal prefix
        subject.set(new_prefix, 3)
        subject.find(3).must_equal new_prefix
      end
    end

    describe '#delete' do
      let(:prefix) { Myaso::Prefix.new(3, 'foo') }

      it 'should remove an existent prefix' do
        subject.find(3).must_be_nil
        subject.set(prefix, 3)
        subject.find(3).must_equal prefix
        subject.delete(3).must_equal true
        subject.find(3).must_be_nil
      end

      it 'should not remove an existent prefix' do
        subject.find(3).must_be_nil
        subject.delete(3).must_equal false
      end
    end

    describe '#size' do
      it 'should be valid' do
        subject.size.must_equal 2
      end
    end
  end
end
