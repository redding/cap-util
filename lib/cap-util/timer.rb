require 'cap-util'

module CapUtil
  class Timer

    def self.pretty_time(elapsed)
      "#{elapsed / 60}:#{(elapsed % 60).to_s.rjust(2, '0')}"
    end

    attr_reader :name, :start_time, :end_time, :elapsed_time

    def initialize(name, quiet=nil)
      @name, @start_time, @end_time, @elapsed_time = name, 0, 0, 0
      @quiet = !!(quiet == :quiet)
    end

    def start(time=nil)
      CapUtil.say "    Starting #{CapUtil.color @name, :cyan}." if !@quiet
      @start_time = (time || ::Time.now)
    end

    def end(time=nil)
      @end_time = (time || ::Time.now)
      @elapsed_time = @end_time - @start_time
      if !@quiet
        elapsed = self.class.pretty_time(@elapsed_time.to_i)
        CapUtil.say "    #{CapUtil.color @name, :bold, :yellow} completed in"\
                    " #{CapUtil.color elapsed, :underline, :yellow}."
      end
      @end_time
    end

  end
end
