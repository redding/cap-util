require 'yaml'
require 'cap-util'

module CapUtil

  # the class should be use as a superclass for fetching server roles yaml.

  class ServerRolesYaml
    include CapUtil
    attr_reader :desc, :source

    def initialize(cap, opts=nil)
      opts ||= {}

      @cap    = cap
      @desc   = opts[:desc]   ? "#{opts[:desc]} server roles" : "server roles"
      @source = opts[:source] ? " from #{opts[:source]}" : ""
    end

    def get
      say "Applying #{color @desc, :bold, :cyan}#{@source}."

      validate
      valid? ? read : halt
    end

    def validate; raise NotImplementedError; end
    def valid?;   raise NotImplementedError; end
    def read;     raise NotImplementedError; end

  end

end
