# encoding: utf-8

class MiniTest::Unit::TestCase
  def self.should_behave_like_a_rules!
    describe '#get' do
      it 'should fetch a prefix' do
        subject.find(1).must_equal('rule_set_id' => '1')
      end

      it 'should fetch a prefix in UTF-8' do
        subject.find(2).must_equal('rule_set_id' => '1',
                                   'suffix' => 's')
      end

      it 'should return nil when prefix is absent' do
        subject.find(3).must_be_nil
      end
    end
  end
end
