require 'scmd'

module CapUtil

  class LocalCmdRunner
    def initialize(cmd_str)
      @cmd = Scmd.new(cmd_str)
    end

    def run!(input=nil)
      CapUtil.say_bulleted "running `#{@cmd}'"
      @cmd.run(input)

      if !@cmd.success?
        CapUtil.say_error(@cmd.stderr)
        CapUtil.halt
      end
      @cmd
    end
  end

  def self.run_locally(cmd_str)
    LocalCmdRunner.new(cmd_str).run!
  end

  def self.run_locally_with_stdin(cmd_str, input)
    LocalCmdRunner.new(cmd_str).run!(input)
  end

  module Run

    def self.included(receiver)
      receiver.send(:extend,  RunLocalMethods)
      receiver.send(:include, RunLocalMethods)
      receiver.send(:include, InstanceMethods)
    end

    module RunLocalMethods
      def run_locally(*args); CapUtil.run_locally(*args); end
      def run_locally_with_stdin(*args); CapUtil.run_locally_with_stdin(*args); end
    end

    module InstanceMethods

      def run(*args, &block)
        cap.run(*args, &block)
      end

      def run_with_stdin(cmd_str, input, opts={})
        run(cmd_str, opts.merge(:pty => true)) {|ch, stream, out| ch.send_data(input + "\n")}
      end

      def run_as(user, cmd_str, opts={}, &block)
        as_cmd_str = "su #{user} -lc '#{cmd_str.gsub("'", "\\'")}'"
        run(as_cmd_str, opts, &block)
      end

      def run_as_with_stdin(user, cmd_str, input, opts={})
        run_as(user, cmd_str, opts) {|ch, stream, out| ch.send_data(input + "\n")}
      end

    end

  end
end
