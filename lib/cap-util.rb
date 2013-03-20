require 'cap-util/version'
require 'cap-util/say'
require 'cap-util/halt'
require 'cap-util/run'
require 'cap-util/time'
require 'cap-util/unset_var'

module CapUtil

  def self.included(receiver)
    receiver.send(:attr_accessor, :cap)

    receiver.send(:include, CapUtil::Say)
    receiver.send(:include, CapUtil::Halt)
    receiver.send(:include, CapUtil::Run)
    receiver.send(:include, CapUtil::Time)
  end

  def get(*args, &block)
    cap.get(*args, &block)
  end

  def hostname
    val = ""
    run("hostname") {|ch, stream, out| val = out.strip}
    val
  end

end
