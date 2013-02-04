require 'capistrano/cli'

module CapUtil

  def self.color(*args)
    Capistrano::CLI.ui.color(*args)
  end

  def self.say(msg, *args)
    say_raw("    #{msg}", *args)
  end

  def self.say_bulleted(msg, *args)
    say_raw("  * #{msg}", *args)
  end

  def self.say_error(msg, *args)
    say("#{color "[ERROR]", :bold, :red} #{msg}", *args)
  end

  def self.say_warning(msg, *args)
    say("#{color "[WARN]", :bold, :yellow} #{msg}", *args)
  end

  def self.say_raw(msg, *args)
    Capistrano::CLI.ui.say(msg, *args) if !ENV['CAPUTIL_SILENCE_SAY']
  end

  module Say

    def self.included(receiver)
      receiver.send(:extend,  SayMethods)
      receiver.send(:include, SayMethods)
    end

    module SayMethods
      def color(*args);        CapUtil.color(*args);        end
      def say(*args);          CapUtil.say(*args);          end
      def say_bulleted(*args); CapUtil.say_bulleted(*args); end
      def say_error(*args);    CapUtil.say_error(*args);    end
      def say_warning(*args);  CapUtil.say_warning(*args);  end
    end

  end
end
