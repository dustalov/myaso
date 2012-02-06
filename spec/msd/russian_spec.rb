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

    it 'should be parsed fine' do
      until @tsv.eof?
        line = @tsv.shift
        ref_msd = Myaso::MSD.new(Russian, line[0])
        ref_msd.validate.must_equal true
      end
    end
  end
end
