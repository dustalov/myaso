# encoding: utf-8

require File.expand_path('../../spec_helper', __FILE__)

require 'csv'
require 'myaso/msd/russian'

class Myaso::MSD
  describe Russian do
    before do
      table_filename = File.expand_path('../russian.tsv', __FILE__)
      @tsv = CSV.open(table_filename, 'rb', :col_sep => "\t")
      @header = @tsv.shift
    end

    after do
      @tsv.close
    end

    it 'should be parsed' do
      until @tsv.eof?
        Myaso::MSD.new(Russian, @tsv.shift.first[0]).must_be :valid?
      end
    end
  end
end
