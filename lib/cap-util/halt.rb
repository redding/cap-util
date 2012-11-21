module CapUtil

  class Halted < RuntimeError
    def backtrace; []; end
  end

  def self.halt(msg='halted')
    raise CapUtil::Halted, color(msg, :bold, :yellow)
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
