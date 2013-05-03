# encoding: utf-8

describe Myaso::Lexicon do
  subject { Myaso::Lexicon.new }

  describe '#new' do
    it 'should be empty' do
      subject.table.must_be_empty
    end

    it 'should not initialize @tags' do
      subject.instance_variable_get(:@tags).must_be_nil
    end
  end

  describe '#[]' do
    it 'should treat unknown words as zeroes' do
      subject['lopata'].must_equal 0
    end

    it 'should treat unknown words and tags as zeroes' do
      subject['lopata', 'dno'].must_equal 0
    end

    it 'should modify a word' do
      subject['lopata'] = 1
      subject['lopata'].must_equal 1
    end

    it 'should modify a word with tag' do
      subject['lopata', 'dno'] = 2
      subject['lopata', 'dno'].must_equal 2
    end
  end

  describe '#tags' do
    it 'should perform lazy initialization' do
      subject.instance_variable_get(:@tags).must_be_nil
      subject.tags
      subject.instance_variable_get(:@tags).wont_be_nil
    end

    it 'should collect global tag counts' do
      subject['lopata', 'dno'] = 1
      subject['lopata', 'bydlow'] = 2
      subject.tags.must_equal 'dno' => 1, 'bydlow' => 2
    end

    it 'should be invalidated after the value assignment' do
      subject.tags.must_be_empty
      subject['lopata', 'dno'] = 1
      subject.tags.must_equal 'dno' => 1
    end

    it 'should return tags of the given word' do
      subject.tags('lopata').must_be_empty
      subject['lopata', 'dno'] = 1
      subject.tags('lopata').must_equal %w(dno)
    end
  end

  describe '#each' do
    it 'should iterate over the internal table' do
      subject.each.to_a.must_equal subject.table.to_a
    end
  end

  describe '#==' do
    let(:other) { Myaso::Lexicon.new }

    it 'should be equal to a new instance when not modified' do
      subject.must_equal other
    end

    it 'should check equality by internal tables' do
      subject['lopata', 'dno'] = 1
      subject.wont_equal other
      other['lopata', 'dno'] = 1
      subject.must_equal other
    end
  end
end
