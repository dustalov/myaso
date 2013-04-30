# encoding: utf-8

describe Myaso::Ngrams do
  let(:tags) { %w(D V N) }
  let(:unigrams) { tags }
  let(:bigrams) { tags + [nil] }
  let(:trigrams) { tags + [nil] }

  subject { Myaso::Ngrams.new }

  describe '#new' do
    it 'should be full of zeroes' do
      unigrams.each do |u|
        bigrams.each do |b|
          trigrams.each do |t|
            subject[u, b, t].must_equal 0
          end
        end
      end
    end
  end

  describe '#[]' do
    it 'should treat unset unigrams as zeroes' do
      subject['D'].must_equal 0
    end

    it 'should treat unset bigrams as zeroes' do
      subject['D', 'V'].must_equal 0
    end

    it 'should treat unset trigrams as zeroes' do
      subject['D', 'V', 'N'].must_equal 0
    end

    it 'should modify an unigram' do
      subject['D'] = 1
      subject['D'].must_equal 1
    end

    it 'should modify a bigram' do
      subject['D', 'N'] = 2
      subject['D', 'N'].must_equal 2
    end

    it 'should modify a trigram' do
      subject['D', 'N', 'V'] = 3
      subject['D', 'N', 'V'].must_equal 3
    end
  end

  describe '#each' do
    it 'should iterate over the internal table' do
      subject.each.to_a.must_equal subject.table.to_a
    end
  end

  describe '#==' do
    let(:other) { Myaso::Ngrams.new }

    it 'should be equal to a new instance when not modified' do
      subject.must_equal other
    end

    it 'should check equality by internal tables' do
      subject['D', 'N', 'V'] = 1
      subject.wont_equal other
      other['D', 'N', 'V'] = 1
      subject.must_equal other
    end
  end
end
