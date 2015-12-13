require 'assert'
require 'cap-util/shared_path'

require 'fileutils'
require 'pathname'

class CapUtil::SharedPath

  class UnitTests < Assert::Context
    desc "CapUtil::SharedPath"
    setup do
      @fake_cap = CapUtil::FakeCap.new
      @fake_cap.shared_path = Pathname.new File.expand_path("tmp/shared")

      @shared_path = CapUtil::SharedPath.new(@fake_cap)
    end
    subject{ @shared_path }

    should have_imeths :rm_rf

    should "remove a given relative path with the `rm_rf` method" do
      subject.rm_rf 'cached-copy'
      exp_cmd = "rm -rf #{File.expand_path("tmp/shared/cached-copy")}"

      assert_equal exp_cmd, @fake_cap.cmds_run.last
    end

  end

end
