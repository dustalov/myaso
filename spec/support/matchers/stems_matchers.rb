# encoding: utf-8

class MiniTest::Unit::TestCase
  def self.should_behave_like_a_stems!
    describe '#get' do
      it 'should fetch a stem' do
        subject.find(1).must_equal('rule_set_id' => '1',
                                   'stem' => 'cat')
      end

      it 'should return nil when stem is absent' do
        subject.find(2).must_be_nil
      end
    end

    describe '#set' do
      let(:stem) { { 'stem_set_id' => '1' } }

      it 'should set an empty stem' do
        subject.find(2).must_be_nil
        subject.set(2, stem)
        subject.find(2).must_equal stem
      end

      it 'should replace an existent stem' do
        new_stem = { 'stem_set_id' => '2' }

        subject.find(2).must_be_nil
        subject.set(2, stem)
        subject.find(2).must_equal stem
        subject.set(2, new_stem)
        subject.find(2).must_equal new_stem
      end
    end

    describe '#delete' do
      let(:stem) { { 'stem_set_id' => '1' } }

      it 'should remove an existent stem' do
        subject.find(2).must_be_nil
        subject.set(2, stem)
        subject.find(2).must_equal stem
        subject.delete(2).must_equal true
        subject.find(2).must_be_nil
      end

      it 'should not remove an existent stem' do
        subject.find(2).must_be_nil
        subject.delete(2).must_equal false
      end
    end

    describe '#find_by_stem_and_rule_set_id' do
      it 'should find an existent stem' do
        subject.find_by_stem_and_rule_set_id('cat', 1).
          must_equal('stem' => 'cat',
                     'rule_set_id' => '1')
      end

      it 'should not find an absent stem by invalid stem' do
        subject.find_by_stem_and_rule_set_id('бля', 1).must_be_nil
      end

      it 'should not find an absent stem by invalid rule_set_id' do
        subject.find_by_stem_and_rule_set_id('cat', 2).must_be_nil
      end
    end

    describe '#has_stem?' do
      it 'should check existent stem without rule_set_id' do
        subject.has_stem?('cat').must_equal true
      end

      it 'should check existent stem with rule_set_id' do
        subject.has_stem?('cat', 1).must_equal true
      end

      it 'should check absent stem without rule_set_id' do
        subject.has_stem?('бля').must_equal false
      end

      it 'should check absent stem with rule_set_id' do
        subject.has_stem?('cat', 2).must_equal false
      end
    end

    describe '#select' do
      it 'should select existent stems' do
        subject.select('cat').size.must_equal 1
      end

      it 'should not select absent stems' do
        subject.select('бля').size.must_equal 0
      end
    end

    describe '#select_by_ending' do
      it 'should select by existent ending without rule_set_id' do
        subject.select_by_ending('t').size.must_equal 1
        subject.select_by_ending('at').size.must_equal 1
        subject.select_by_ending('cat').size.must_equal 1
      end

      it 'should select by existent ending with rule_set_id' do
        subject.select_by_ending('t', 1).size.must_equal 1
        subject.select_by_ending('at', 1).size.must_equal 1
        subject.select_by_ending('cat', 1).size.must_equal 1
      end

      it 'should not select by absent ending without rule_set_id' do
        subject.select_by_ending('я').size.must_equal 0
        subject.select_by_ending('ля').size.must_equal 0
        subject.select_by_ending('бля').size.must_equal 0
      end

      it 'should not select by absent ending with rule_set_id' do
        subject.select_by_ending('t', 2).size.must_equal 0
        subject.select_by_ending('at', 2).size.must_equal 0
        subject.select_by_ending('cat', 2).size.must_equal 0
      end
    end

    describe '#size' do
      it 'should be valid' do
        subject.size.must_equal 1
      end
    end
  end
end
