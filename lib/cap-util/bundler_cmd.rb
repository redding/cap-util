require 'cap-util'

module CapUtil

  # This defines a base utiltiy for building bundler commands to run.

  class BundlerCmd
    include CapUtil

    attr_reader :cmd

    def initialize(cap, cmd, opts = nil)
      opts ||= {}
      @cap = cap

      opts[:root] ||= :current_path
      opts[:env]  ||= ""

      cmd_root = @cap.send(opts[:root])

      @cmd = "cd #{cmd_root} && #{opts[:env]} bundle exec #{cmd}"
    end

    def run; super(@cmd); end

    module TestHelpers

      def assert_bundler_cmd(util, *args)
        with_backtrace(caller) do
          assert_kind_of BundlerCmd, util

          exp = BundlerCmd.new(*args)
          assert_equal exp.cmd, util.cmd
        end
      end

    end

  end

end
