# encoding: utf-8

class MiniTest::Unit::TestCase
  def self.should_behave_like_a_rules!
    describe '#get' do
      it 'should fetch a rule' do
        subject.find(1).must_equal('rule_set_id' => '1')
      end

      it 'should fetch a rule in UTF-8' do
        subject.find(2).must_equal('rule_set_id' => '1',
                                   'suffix' => 's')
      end

      it 'should return nil when rule is absent' do
        subject.find(3).must_be_nil
      end
    end

    describe '#set' do
      let(:rule) { { 'rule_set_id' => '1' } }

      it 'should set an empty rule' do
        subject.find(3).must_be_nil
        subject.set(3, rule)
        subject.find(3).must_equal rule
      end

      it 'should replace an existent rule' do
        new_rule = { 'rule_set_id' => '2' }

        subject.find(3).must_be_nil
        subject.set(3, rule)
        subject.find(3).must_equal rule
        subject.set(3, new_rule)
        subject.find(3).must_equal new_rule
      end
    end

    describe '#delete' do
      let(:rule) { { 'rule_set_id' => '1' } }

      it 'should remove an existent rule' do
        subject.find(3).must_be_nil
        subject.set(3, rule)
        subject.find(3).must_equal rule
        subject.delete(3).must_equal true
        subject.find(3).must_be_nil
      end

      it 'should not remove an existent rule' do
        subject.find(3).must_be_nil
        subject.delete(3).must_equal false
      end
    end
  end
end
