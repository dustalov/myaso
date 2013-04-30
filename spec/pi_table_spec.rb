# encoding: utf-8

describe Myaso::PiTable do
  let(:length) { 10 }
  let(:tags) { %w(D V N) }

  subject { Myaso::PiTable.new }

  describe '#new' do
    it 'should be full of nils' do
      length.times do |i|
        tags.each do |u|
          tags.each do |v|
            subject[i, u, v].must_be_nil
          end
        end
      end
    end

    describe 'with default value' do
      let(:default) { 0 }

      subject { Myaso::PiTable.new(default) }

      it 'should be full of zeros' do
        length.times do |i|
          tags.each do |u|
            tags.each do |v|
              subject[i, u, v].must_equal 0
            end
          end
        end
      end
    end
  end

  describe '#[]' do
    it 'should get and set a tuple' do
      subject[0, 'D', 'N'] = 1
      subject[0, 'D', 'V'] = 2
      subject[0, 'D', 'N'].must_equal 1
      subject[0, 'D', 'V'].must_equal 2
    end
  end

  describe '#each' do
    it 'iterates over an internal table' do
      subject.each.to_a.must_equal subject.table.to_a
    end
  end
end
