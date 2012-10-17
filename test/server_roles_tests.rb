require 'assert'

require 'cap-util/server_roles'

module CapUtil

  class ServerRolesTests < Assert::Context
    desc "the ServerRoles handler"
    setup do
      roles_yaml = <<YAML
---
hosts:
  host1: [primary]
  host2: []
YAML
      @fake_cap = FakeCap.new
      @server_roles = ServerRoles.new(@fake_cap, roles_yaml)
    end
    subject { @server_roles }

    should have_reader :roles
    should have_imeth :apply

    should "build cap roles from yaml using the apply meth" do
      subject.apply
      roles = @fake_cap.roles.sort{|a,b| a[1] <=> b[1]}

      assert_equal 2, @fake_cap.roles.size
      assert_equal ['hosts', 'host2.reelfx.com', {}], roles.last
    end

  end

  class ServerRoles

    class RoleSetTests < Assert::Context
      desc "the server roles RoleSet"
      setup do
        @roles_hash = {
          'hosts' => {
            'host1' => ['primary'],
            'host2' => []
          }
        }
        @role_set = RoleSet.new @roles_hash
      end
      subject { @role_set }

      should have_reader :role_defs
      should have_imeth :each

      should "yield the name, hostname, and opts for each host/server when iterating the roles" do
        exp = [
          ['hosts', 'host1.reelfx.com', {:primary => true, 'primary' => true}],
          ['hosts', 'host2.reelfx.com', {}]
        ]
        actual = []
        subject.each do |name, host, opts|
          actual << [name, host, opts]
        end

        assert_equal exp, actual.sort{|a, b| a[1] <=> b[1]}
      end
    end

    class RoleDefTests < RoleSetTests
      desc "the server roles RoleDef"
      setup do
        @role_servers_hash = {
          'host1' => ['primary'],
          'host2' => []
        }
        @role = RoleDef.new('hosts', @role_servers_hash)
      end
      subject { @role }

      should have_reader :name, :servers
      should have_imeth :apply

      should "build a set of servers from a definition hash" do
        servs = subject.servers.sort{|a, b| a.hostname <=> b.hostname }

        assert_kind_of ::Array, servs
        assert_equal 2, servs.size
        assert_kind_of ServerDef, servs.first
        assert_equal 'host2.reelfx.com', servs.last.hostname
        assert_equal true, servs.first.options['primary']
      end

    end

    class ServerDefTests < Assert::Context
      desc "the server roles ServerDef"
      setup do
        @server = ServerDef.new('host1')
      end
      subject { @server }

      should have_readers :hostname, :options

      should "build its hostname from the server name" do
        assert_equal "host1.reelfx.com", subject.hostname
      end

      should "have no options by defoult" do
        assert_empty subject.options
      end

      should "build its options with both string and symbol keys" do
        server = ServerDef.new('opts1', 'primary')

        assert_equal true, server.options[:primary]
        assert_equal true, server.options['primary']
      end

    end

  end

end
