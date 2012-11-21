require 'assert'

require 'cap-util/run'

module CapUtil

  class LocalCmdRunnerTests < Assert::Context
    desc "the local cmd runner helper class"
    setup do
      @cmd_runner = LocalCmdRunner.new("echo hi")
    end
    subject { @cmd_runner }

    should have_imeth :run!

  end

end
