require 'assert'
require 'cap-util/fake_cap'

class CapUtil::FakeCap

  class BaseTests < Assert::Context
    desc "the fake cap helper"
    setup do
      @fc = CapUtil::FakeCap.new
    end
    subject { @fc }

    should have_imeths :method_missing, :respond_to?
    should have_imeths :run, :sudo, :fetch, :role
    should have_readers :roles, :cmds_run

    should "store off cmds that have been run" do
      assert_empty subject.cmds_run

      subject.run('a_cmd', 1)
      assert_equal 'a_cmd', subject.cmds_run.last

      subject.sudo('a_cmd', 1)
      assert_equal 'sudo a_cmd', subject.cmds_run.last
    end

  end

end
