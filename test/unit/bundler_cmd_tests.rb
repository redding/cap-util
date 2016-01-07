require 'assert'
require 'cap-util/bundler_cmd'

class CapUtil::BundlerCmd

  class UnitTests < Assert::Context
    desc "CapUtil::BundlerCmd"
    setup do
      @fake_cap = CapUtil::FakeCap.new
      @fake_cap.current_path = "/a/current/path"
      @fake_cap.release_path = "/dat/release/path"

      @util = CapUtil::BundlerCmd.new(@fake_cap, 'ls -la')
    end
    subject{ @util }

    should have_imeths :run

    should "build a bundler cmd to run" do
      assert_includes '&&  bundle exec ls -la', subject.cmd
    end

    should "use cap's current path by default" do
      assert_includes "cd #{@fake_cap.current_path} &&", subject.cmd
    end

    should "use a custom cap path if given" do
      util = CapUtil::BundlerCmd.new(@fake_cap, '', :root => :release_path)
      assert_includes "cd #{@fake_cap.release_path} &&", util.cmd
    end

    should "use a custom env var string if given" do
      util = CapUtil::BundlerCmd.new(@fake_cap, 'ls -la', :env => "FOO=bar")
      assert_includes "&& FOO=bar bundle exec ls", util.cmd
    end

    should "run its cmd" do
      exp_cmd = "cd /a/current/path &&  bundle exec ls -la"
      subject.run

      assert_equal exp_cmd, @fake_cap.cmds_run.last
    end

  end

  class TestHelpersTests < UnitTests
    include TestHelpers

    desc "TestHelpers"
    setup do
      @context = Class.new{ include TestHelpers }.new
    end
    subject{ @context }

    should have_imeths :assert_bundler_cmd

    should "prove a util is a bundler cmd that was built correctly" do
      assert_bundler_cmd(@util, @fake_cap, 'ls -la')
      assert_bundler_cmd(@util, @fake_cap, 'ls -la', :root => :current_path)
      assert_bundler_cmd(@util, @fake_cap, 'ls -la', :env  => '')

      util = CapUtil::BundlerCmd.new(@fake_cap, 'ls -la', {
        :root => :release_path,
        :env  => "FOO=bar"
      })
      assert_bundler_cmd(util, @fake_cap, 'ls -la', {
        :root => :release_path,
        :env  => "FOO=bar"
      })
    end

  end

end
