# encoding: utf-8

class MiniTest::Unit::TestCase
  def self.should_behave_like_a_rules!
    describe '#get' do
      it 'should fetch a rule' do
        subject.find(1).must_equal('rule_set_id' => '1',
                                   'msd' => 'Nc-s')
      end

      it 'should return nil when rule is absent' do
        subject.find(5).must_be_nil
      end
    end

    describe '#set' do
      let(:rule) { { 'rule_set_id' => '1' } }

      it 'should set an empty rule' do
        subject.find(5).must_be_nil
        subject.set(5, rule)
        subject.find(5).must_equal rule
      end

      it 'should replace an existent rule' do
        new_rule = { 'rule_set_id' => '2' }

        subject.find(5).must_be_nil
        subject.set(5, rule)
        subject.find(5).must_equal rule
        subject.set(5, new_rule)
        subject.find(5).must_equal new_rule
      end
    end

    describe '#delete' do
      let(:rule) { { 'rule_set_id' => '1' } }

      it 'should remove an existent rule' do
        subject.find(5).must_be_nil
        subject.set(5, rule)
        subject.find(5).must_equal rule
        subject.delete(5).must_equal true
        subject.find(5).must_be_nil
      end

      it 'should not remove an existent rule' do
        subject.find(5).must_be_nil
        subject.delete(5).must_equal false
      end
    end

    describe '#find_rule' do
      it 'should find rules without suffix' do
        subject.find_rule('1', nil).
          must_equal('rule_set_id' => '1',
                     'msd' => 'Nc-s')
      end

      it 'should find an existent rule by required arguments' do
        subject.find_rule('1', 's').
          must_equal('rule_set_id' => '1',
                     'suffix' => 's',
                     'msd' => 'Nc-p')
      end

      it 'should not find absent rule by required arguments' do
        subject.find_rule('1', 'r').must_be_nil
      end
    end

    describe '#has_suffix?' do
      it 'should check nil suffix' do
        subject.has_suffix?(nil).must_equal true
      end

      it 'should check existent suffix' do
        subject.has_suffix?('s').must_equal true
      end

      it 'should check absent suffix' do
        subject.has_suffix?('бля').must_equal false
      end
    end

    describe '#select_by_rule_set' do
      it 'should select existent rules' do
        subject.select_by_rule_set(1).size.must_equal 4
      end

      it 'should not select absent rules' do
        subject.select_by_rule_set(2).size.must_equal 0
      end
    end

    describe '#select_by_prefix' do
      it 'should select existent rules without rule_set_id' do
        subject.select_by_prefix('ani').size.must_equal 2
      end

      it 'should select existent rules with rule_set_id' do
        subject.select_by_prefix('ani', 1).size.must_equal 2
      end

      it 'should not select absent rules without rule_set_id' do
        subject.select_by_prefix('бля').size.must_equal 0
      end

      it 'should not select absent rules with rule_set_id' do
        subject.select_by_prefix('ani', 2).size.must_equal 0
      end
    end

    describe '#select_by_suffix' do
      it 'should select existent rules without rule_set_id' do
        subject.select_by_suffix('s').size.must_equal 2
      end

      it 'should select existent rules with rule_set_id' do
        subject.select_by_suffix('s', 1).size.must_equal 2
      end

      it 'should not select absent rules without rule_set_id' do
        subject.select_by_suffix('бля').size.must_equal 0
      end

      it 'should not select absent rules with rule_set_id' do
        subject.select_by_suffix('s', 2).size.must_equal 0
      end
    end
  end
end
