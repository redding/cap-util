require 'cap-util/timer'

module CapUtil

  def self.time(timer_set, name, &block)
    timer_set[name] ||= CapUtil::Timer.new(name)
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
      receiver.send(:extend,  ClassMethods)
      receiver.send(:include, InstanceMethods)
    end

    module ClassMethods
      def time(*args, &block); CapUtil.time(*args, &block); end
    end

    module InstanceMethods
      def time(name, &block)
        @cap_util_timers ||= {}
        CapUtil.time(@cap_util_timers, name, &block)
      end
    end

  end
end
