require 'assert'
require 'cap-util/run'

class CapUtil::LocalCmdRunner

  class BaseTests < Assert::Context
    desc "the local cmd runner helper class"
    setup do
      @cmd_runner = CapUtil::LocalCmdRunner.new("echo hi")
    end
    subject { @cmd_runner }

    should have_imeth :run!

  end

end
