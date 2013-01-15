require 'assert'

require 'cap-util/fake_cap'

module CapUtil

  class FakeCapTests < Assert::Context
    desc "the fake cap helper"
    setup do
      @fc = FakeCap.new
    end
    subject { @fc }

    should have_imeths :method_missing, :respond_to?
    should have_imeths :run, :fetch, :role
    should have_readers :roles, :cmds_run

    should "store off cmds that have been run" do
      assert_empty subject.cmds_run

      subject.run('a_cmd', 1)
      assert_equal 'a_cmd', subject.cmds_run.last
    end

  end

end
