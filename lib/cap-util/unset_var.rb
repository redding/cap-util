require 'cap-util/halt'

module CapUtil
  module UnsetVar

    def self.new(name, msg=nil)
      halt_msg = msg ? ":#{name} var not set (#{msg})." : ":#{name} var not set."
      Proc.new { CapUtil.halt(halt_msg) }
    end

  end
end
