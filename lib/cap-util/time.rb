require 'cap-util/timer'

module CapUtil

  def self.time(timer_set, name, &block)
    timer_set[name] = CapUtil::Timer.new(name)
    if !block.nil?
      begin
        timer_set[name].start
        block.call
      ensure
        timer_set[name].end
      end
    end
    timer_set[name]
  end

  module Time

    def self.included(receiver)
      receiver.send(:extend,  TimeMethods)
      receiver.send(:include, TimeMethods)
    end

    module TimeMethods
      def time(*args, &block); CapUtil.time(*args, &block); end
    end

  end
end
