require 'assert'
require 'cap-util/unset_var'

module CapUtil::UnsetVar

  class UnitTests < Assert::Context
    desc "CapUtil::UnsetVar"
    setup do
      @var_name = 'test'
      @unset = CapUtil::UnsetVar.new(@var_name)
    end
    subject{ @unset }

    should "be a proc" do
      assert_kind_of ::Proc, subject
    end

    should "raise `Halted` when called" do
      assert_raises(CapUtil::Halted) { subject.call }
    end

    should "raise with a default msg based on the variable name" do
      exp_msg = ":#{@var_name} var not set."
      begin
        subject.call
      rescue CapUtil::Halted => err
        assert_match exp_msg, err.message
      end
    end

    should "accept a custom msg to raise with" do
      exp_msg = ":#{@var_name} var not set (a custom err msg)."
      unset = CapUtil::UnsetVar.new(@var_name, exp_msg)
      begin
        unset.call
      rescue CapUtil::Halted => err
        assert_match exp_msg, err.message
      end
    end

  end

end
