require 'assert'
require 'cap-util/rake_task'

class CapUtil::RakeTask

  class BaseTests < Assert::Context
    desc "the rake task util"
    setup do
      @fake_cap = CapUtil::FakeCap.new
      @fake_cap.fetch_rake = "bundle exec rake"
      @fake_cap.current_path = "/a/current/path"
      @fake_cap.release_path = "/dat/release/path"
      @rake_task_util = CapUtil::RakeTask.new(@fake_cap, 'a:task:to:run')
    end
    subject { @rake_task_util }

    should have_imeths :run

    should "build a rake task to run" do
      assert_match 'rake ', subject.cmd
      assert_match ' a:task:to:run', subject.cmd
    end

    should "run the task with bundler by default" do
      assert_match 'bundle exec rake', subject.cmd
    end

    should "run the task with a custom rake if given" do
      task = CapUtil::RakeTask.new(@fake_cap, '', :rake => '/path/to/rake')
      assert_match '/path/to/rake', task.cmd
    end

    should "use cap's current path by default" do
      assert_match "cd #{@fake_cap.current_path} &&", subject.cmd
    end

    should "use a custom cap path if given" do
      task = CapUtil::RakeTask.new(@fake_cap, '', :root => :release_path)
      assert_match "cd #{@fake_cap.release_path} &&", task.cmd
    end

    should "use a custom env var string if given" do
      task = CapUtil::RakeTask.new(@fake_cap, '', :env => "FOO=bar")
      assert_match "FOO=bar bundle", task.cmd
    end

    should "run its rake cmd" do
      exp_cmd = "cd /a/current/path &&  bundle exec rake a:task:to:run"
      subject.run

      assert_equal exp_cmd, @fake_cap.cmds_run.last
    end

  end

end
