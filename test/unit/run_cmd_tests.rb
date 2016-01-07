require 'assert'
require 'cap-util/run_cmd'

class CapUtil::RunCmd

  class UnitTests < Assert::Context
    desc "CapUtil::RunCmd"
    setup do
      @fake_cap = CapUtil::FakeCap.new
      @fake_cap.current_path = "/a/current/path"
      @fake_cap.release_path = "/dat/release/path"

      @util = CapUtil::RunCmd.new(@fake_cap, 'ls -la')
    end
    subject{ @util }

    should have_imeths :run

    should "build a cmd to run" do
      assert_includes '&&  ls -la', subject.cmd
    end

    should "use cap's current path by default" do
      assert_includes "cd #{@fake_cap.current_path} &&", subject.cmd
    end

    should "use a custom cap path if given" do
      run_cmd = CapUtil::RunCmd.new(@fake_cap, '', :root => :release_path)
      assert_includes "cd #{@fake_cap.release_path} &&", run_cmd.cmd
    end

    should "use a custom env var string if given" do
      run_cmd = CapUtil::RunCmd.new(@fake_cap, 'ls -la', :env => "FOO=bar")
      assert_includes "&& FOO=bar ls", run_cmd.cmd
    end

    should "run its cmd" do
      exp_cmd = "cd /a/current/path &&  ls -la"
      subject.run

      assert_equal exp_cmd, @fake_cap.cmds_run.last
    end

  end

end
