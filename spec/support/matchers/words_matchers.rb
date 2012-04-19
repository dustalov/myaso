# encoding: utf-8

class MiniTest::Unit::TestCase
  def self.should_behave_like_a_words!
    describe '#get' do
      it 'should fetch a word' do
        subject.find(1).must_equal('stem_id' => '1',
                                   'rule_id' => '1')

        subject.find(2).must_equal('stem_id' => '1',
                                   'rule_id' => '2')
      end

      it 'should return nil when word is absent' do
        subject.find(3).must_be_nil
      end
    end

    describe '#set' do
      let(:word) { { 'stem_id' => '1', 'rule_id' => '1' } }

      it 'should set an empty word' do
        subject.find(3).must_be_nil
        subject.set(3, word)
        subject.find(3).must_equal word
      end

      it 'should replace an existent word' do
        new_word = { 'stem_id' => '1', 'rule_id' => '1' }

        subject.find(3).must_be_nil
        subject.set(3, word)
        subject.find(3).must_equal word
        subject.set(3, new_word)
        subject.find(3).must_equal new_word
      end
    end

    describe '#delete' do
      let(:word) { { 'stem_id' => '1', 'rule_id' => '1' } }

      it 'should remove an existent word' do
        subject.find(3).must_be_nil
        subject.set(3, word)
        subject.find(3).must_equal word
        subject.delete(3).must_equal true
        subject.find(3).must_be_nil
      end

      it 'should not remove an existent word' do
        subject.find(3).must_be_nil
        subject.delete(3).must_equal false
      end
    end

    describe '#find_by_stem_id_and_rule_id' do
      it 'should select existent words' do
        subject.find_by_stem_id_and_rule_id(1, 1).must_equal('1')
      end

      it 'should not select absent words' do
        subject.find_by_stem_id_and_rule_id(2, 1).must_be_nil
      end
    end

    describe '#select' do
      it 'should select existent words' do
        subject.select(1, 1).size.must_equal 1
      end

      it 'should not select absent words' do
        subject.select(2, 1).size.must_equal 0
      end
    end

    describe '#select_by_stem_id' do
      it 'should select existent words by stem_id' do
        subject.select_by_stem_id(1).size.must_equal 2
      end

      it 'should not select absent words by stem_id' do
        subject.select_by_stem_id(2).size.must_equal 0
      end
    end

    describe '#select_by_rule_id' do
      it 'should select existent words by rule_id' do
        subject.select_by_rule_id(1).size.must_equal 1
        subject.select_by_rule_id(2).size.must_equal 1
      end

      it 'should not select absent words by rule_id' do
        subject.select_by_rule_id(3).size.must_equal 0
      end
    end

    describe '#size' do
      it 'should be valid' do
        subject.size.must_equal 2
      end
    end
  end
end
