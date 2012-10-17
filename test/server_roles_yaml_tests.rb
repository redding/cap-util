require 'assert'

require 'cap-util/server_roles_yaml'

module CapUtil

  class ServerRolesYamlTests < Assert::Context
    desc "the ServerRolesYaml util"
    setup do
      @roles_yaml = ServerRolesYaml.new(FakeCap.new )
    end
    subject { @roles_yaml }

    should have_imeths :get, :validate, :valid?, :read
    should have_reader :desc, :source

    should "default the yaml's desc and source" do
      assert_equal "server roles", subject.desc
      assert_equal "", subject.source
    end

    should "use a custom desc and source if given" do
      yml = ServerRolesYaml.new(FakeCap.new, {
        :desc => 'staging',
        :source => 'the place'
      })
      assert_equal "staging server roles", yml.desc
      assert_equal " from the place", yml.source
    end

    should "raise appropriate NotImplementedErrors" do
      assert_raises(NotImplementedError) { subject.validate }
      assert_raises(NotImplementedError) { subject.valid? }
      assert_raises(NotImplementedError) { subject.read }
    end

  end

end
