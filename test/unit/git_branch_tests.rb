require 'assert'
require 'cap-util/git_branch'

class CapUtil::GitBranch

  class UnitTests < Assert::Context
    desc "CapUtil::GitBranch"
    subject{ CapUtil::GitBranch }

    should have_imeth :current

    should "use the symbolic ref the HEAD is at for the current branch" do
      assert_equal "git symbolic-ref HEAD", subject.current(:cmd)
    end

  end

end
