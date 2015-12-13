require 'assert'
require 'cap-util'

require 'test/support/a_cap_util'

module CapUtil

  class ModuleSystemTests < Assert::Context
    desc "CapUtil the module"
    setup do
      @mod = CapUtil
    end
    subject { @mod }

    should have_imeth :halt, :time
    should have_imeths :color, :say, :say_bulleted, :say_error, :say_warning
    should have_imeths :run_locally, :run_locally_with_stdin

  end

  class HaltTests < ModuleSystemTests
    desc "`halt` methods"

    should "raise a `Halted` custom exception" do
      assert_raises(CapUtil::Halted) { subject.halt }
    end
  end

  class MixinSystemTests < Assert::Context
    desc "CapUtil the mixin"
    setup do
      @cap_util = TestHelpers::ACapUtil.new(CapUtil::FakeCap.new)
    end
    subject { @cap_util }

    should have_accessor :cap

    should have_cmeth :halt
    should have_imeth :halt

    should have_cmeths :color, :say, :say_bulleted, :say_error, :say_warning
    should have_imeths :color, :say, :say_bulleted, :say_error, :say_warning

    should have_cmeths :run_locally, :run_locally_with_stdin
    should have_imeths :run_locally, :run_locally_with_stdin
    should have_imeths :run, :run_with_stdin, :run_as, :run_as_with_stdin
    should have_imeths :sudo

    should have_cmeth :time
    should have_imeth :time

    should have_imeths :get, :hostname

  end

  class HaltedTests < ModuleSystemTests
    desc "Halted"
    setup do
      @err = CapUtil::Halted.new
    end
    subject { @err }

    should "be a `RuntimeError`" do
      assert_kind_of RuntimeError, subject
    end

    should "have no backtrace" do
      assert_empty subject.backtrace
    end

  end

end
