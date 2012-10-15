module CapUtil

  class DeployHalted < RuntimeError
    def backtrace; []; end
  end

  def self.halt(msg='deploy halted')
    raise CapUtil::DeployHalted, color(msg, :bold, :yellow)
  end

  module Halt

    def self.included(receiver)
      receiver.send(:extend,  HaltMethods)
      receiver.send(:include, HaltMethods)
    end

    module HaltMethods
      def halt(*args); CapUtil.halt(*args); end
    end

  end
end
