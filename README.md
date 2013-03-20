# CapUtil

A set of utilities for writing cap tasks.  Use these to help extract business logic from your tasks and test them.

## The Mixin

The main `CapUtil` mixin can be used to make any class a cap utility.  All the cap util requires is that your class define a `cap` method that returns an instance of a cap invocations.  The mixin provides a default `attr_accessor :cap` for you; set an `@cap` instance variable to use it or override it with a custom `def cap` method.

```ruby
# in some_great_util.rb
require 'cap-util'

class SomeGreatUtil
  include CapUtil

  def initialize(cap)
    @cap = cap
  end

  def do_something
    run "echo something"
  end
end

# in Capfile
require 'some_great_util.rb'

desc "some great util"
task :some_great_util do
  SomeGreatUtil.new(self).do_something
end
```

The goal here is to move all cap task business logic into neat little classes that can be unit tested.  In addition, the mixin provides a bunch of helpers for running commands, halting tasks, outputting info, and timing tasks.

## FakeCap helper

The `FakeCap` helper class is handy to use when testing your cap utils.  CapUtil uses it in its own test suite.  It fakes a common subset of cap functions so that they can be safely tested against.  Extend it to suit your own test suite's needs.

## UnsetVar helper

The `UnsetVar` helper class is handy for defining cap vars that need to have a value set in some other context.  Think of it as the equivalent of raising a `NotImplementedError` in a method.  If the variable used without being overridden first, the deploy is halted with a message.

To use:

```ruby
# in your Capfile...

# halt with the default msg ":application var not set."
set :application, CapUtil::UnsetVar.new(:application)

# halt with the custom msg ":stage var not set (no stage task used)."
set :stage, CapUtil::UnsetVar(:stage, "no stage task used")
```

## RakeTask util

This util is handy for running a rake task remotely using a cap task.  It constructs a command that cd's to the rakefile root dir and runs the specified task.  That constructed command that command can then be run using cap.

By default, it expects the rakefile to be in the `:current_path` and uses bundler to run `rake`.  These defaults can be overriden by passing options to the constructor.

To use, do something like:

```ruby
# in your Capfile...

task :some_rake_task do
  CapUtil::RakeTask.new(self, "a:task:to:run").run
end
```

## GitBranch util

This util helps when working with git branches.  Right now, it only has a singleton helpers for fetching the current branch the user is on.  This can be useful in setting the `:branch` cap var if you always want to deploy from the branch you are currently on.

```ruby
set (:branch) { CapUtil::GitBranch.current }
```

## SharedPath util

This utile helps when working with cap's `shared_path`.  Right now, it only has a method for removing things from the shared_path

```ruby
CapUtil::SharedPath.new(self).rm_rf 'cached-copy'
```

## Dynamic Server Roles helpers

CapUtil has a few utils for fetching and applying cap server roles from dynamic data.  It assumes you have your server role data stored in yaml either locally or on some remote location.

### Format

The server role yaml needs to be in a format like:

```yaml
---

app:
  server1: [primary]
  server2: []

db:
  server3: [primary, no_release]
```

### ServerRolesYaml util

This util serves as a base for fetching role yaml data.  It provides a framework for subclasses to override and supply the necessary logic to fetch/validate/read yaml data.  Use it to pull local or remote config files using the given hooks.

### ServerRoles util

This util, given a raw yaml string, will model out the roles and apply them to your cap invocation.

### Example

This example shows how a different set of roles could be used for different stages in cap.  The yaml config files are located local to the 'my_server_roles_yaml.rb' file.

```ruby
# in your Capfile...
require 'my_server_roles_yaml'
set (:server_roles_yaml) { MyServerRolesYaml.new(self, stage) }
set (:server_roles) { CapUtil::ServerRoles.new(self, server_roles_yaml.get) }

# in my_server_roles_yaml.rb

class MyServerRolesYaml < CapUtil::ServerRolesYaml

  # fetch role data from the local config/#{stage}_server_roles.yaml file

  def initialize(cap, stage)
    super(cap, :desc => stage)

    roles_file_name = "#{stage}_server_roles.yaml"
    @roles_file_path = File.expand_path("../../../config/#{roles_file_name}", __FILE__)
  end

  def validate
    if !valid?
      say_error "`#{@roles_file_path}' does not exist."
    end
  end

  def valid?
    File.exists?(@roles_file_path)
  end

  def read
    File.read(@roles_file_path)
  end

end
```

## Installation

Add this line to your application's Gemfile:

    gem 'cap-util'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cap-util

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
