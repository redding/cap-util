require 'assert'

require 'cap-util/git_branch'

module CapUtil

  class GitBranchTests < Assert::Context
    desc "the GitBranch util"
    subject { GitBranch }

    should have_imeth :current

    should "use the symbolic ref the HEAD is at for the current branch" do
      assert_equal "git symbolic-ref HEAD", subject.current(:cmd)
    end

  end

end
