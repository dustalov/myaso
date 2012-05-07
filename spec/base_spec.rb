# encoding: utf-8

require File.expand_path('../spec_helper', __FILE__)

module Myaso
  describe Base do
    subject { Myaso::AllYourBaseAreBelongToUs.new }

    [ :prefixes, :rules, :stems, :words ].each do |name|
      it "has #{name} adapter" do
        subject.must_respond_to name

        klass = subject.class.const_get(name.to_s.capitalize)
        subject.public_send(name).must_be_kind_of klass
      end
    end
  end
end
