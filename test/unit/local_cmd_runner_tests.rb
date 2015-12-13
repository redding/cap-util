require 'assert'
require 'cap-util/local_cmd_runner'

class CapUtil::LocalCmdRunner

  class UnitTests < Assert::Context
    desc "CapUtil::LocalCmdRunner"
    setup do
      @runner = CapUtil::LocalCmdRunner.new("echo hi")
    end
    subject{ @runner }

    should have_imeth :run!

  end

end
