require 'cap-util'

module CapUtil

  # This defines a base utiltiy for building system commands to run.

  class RunCmd
    include CapUtil

    attr_reader :cmd

    def initialize(cap, sys_cmd, opts = nil)
      opts ||= {}
      @cap = cap

      opts[:root] ||= :current_path
      opts[:env]  ||= ""

      cmd_root = @cap.send(opts[:root])

      @cmd = "cd #{cmd_root} && #{opts[:env]} #{sys_cmd}"
    end

    def run; super(@cmd); end

  end

end
