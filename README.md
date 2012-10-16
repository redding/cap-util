# CapUtil

A set of utilities for writing cap tasks.  Use these to help extract business logic from your tasks and test them.

## Installation

Add this line to your application's Gemfile:

    gem 'cap-util'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cap-util

## The Mixin

The main `CapUtil` mixin can be used to make any class a cap utility.  All the cap util requires is that your class define a `cap` method that returns an instance of a cap invocations.

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
