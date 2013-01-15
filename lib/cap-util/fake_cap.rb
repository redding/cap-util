require 'ostruct'

module CapUtil
  class FakeCap

    attr_reader :roles, :cmds_run

    def initialize(*args)
      @struct = OpenStruct.new
      @roles = []
      @cmds_run = []
    end

    def method_missing(method, *args, &block)
      @struct.send(method, *args, &block)
    end

    def respond_to?(method)
      @struct.respond_to?(method) ? true : super
    end

    def run(cmd, *args)
      @cmds_run << cmd
    end

    def fetch(var_name)
      self.send("fetch_#{var_name}")
    end

    def role(name, hostname, opts)
      @roles << [name, hostname, opts]
    end

  end
end
