require 'cap-util'
require 'scmd'

module CapUtil

  class LocalCmdRunner

    def initialize(cmd_str)
      @cmd = Scmd.new(cmd_str)
    end

    def run!(input = nil)
      CapUtil.say_bulleted "running `#{@cmd}'"
      @cmd.run(input)

      if !@cmd.success?
        CapUtil.say_error(@cmd.stderr)
        CapUtil.halt
      end
      @cmd
    end

  end

end
