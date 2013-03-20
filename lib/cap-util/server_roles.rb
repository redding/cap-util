require 'yaml'
require 'cap-util'

module CapUtil

  class ServerRoles
    include CapUtil
    attr_reader :roles

    def initialize(cap, roles_yaml)
      @cap = cap
      @roles = RoleSet.new(YAML.load(roles_yaml))
    end

    # Since this is a CapUtil, we can call cap cmds using the `cap` accessor.
    # For each role, call cap's `role` method, passing the relevant values.

    def apply
      @roles.each do |name, host, opts|
        cap.role name, host, opts
      end

    end

    class RoleSet

      attr_reader :role_defs

      def initialize(roles_hash)
        @role_defs = roles_hash.map do |(role_name, role_servers_hash)|
          RoleDef.new(role_name, role_servers_hash)
        end
      end

      def each(&block)
        @role_defs.each {|role_def| role_def.apply(&block)}
      end

    end

    class RoleDef

      attr_reader :name, :servers

      def initialize(name, servers_hash)
        @name = name
        @servers = servers_hash.map do |(server_name, server_options_list)|
          ServerDef.new(server_name, server_options_list)
        end
      end

      def apply(&block)
        @servers.each do |server|
          block.call @name, server.hostname, server.options
        end
      end

    end

    class ServerDef

      attr_reader :hostname, :options

      def initialize(hostname, options_list=nil)
        @hostname = hostname
        @options = {}

        # so, weird cap bug.  options have to match type when using them in
        # a task's definition.  so if you have (string) 'primary' option, you
        # have to use a string in your task defs.
        # this is not the case for the role names (string or symbol works).
        # so, I'm just defining each option, both in string (how it comes from
        # the configs) and symbol form.

        (options_list || []).each do |option|
          @options[option.to_s]   = true
          @options[option.to_sym] = true
        end
      end

    end

  end

end
