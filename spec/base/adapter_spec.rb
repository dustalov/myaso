# encoding: utf-8

require File.expand_path('../../spec_helper', __FILE__)

class Myaso::Base
  describe Adapter do
    subject { Myaso::AllYourBaseAreBelongToUs.new }

    [ :prefixes, :rules, :stems, :words ].each do |name|
      it "#{name} adapter has its own @base instance variable" do
        subject.send(name).instance_variable_get(:@base).must_equal subject
      end

      # TODO: accessing protected methods from tests is a bad practice
      it "has base attribute accessor" do
        subject.send(name).send(:base).must_equal subject
      end
    end
  end
end
