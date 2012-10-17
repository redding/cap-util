require 'cap-util'

module CapUtil

  # SharedPath models the path to the set of shared deployed code.  named
  # after cap's `shared_path` method b/c they point at similar locations.

  class SharedPath
    include CapUtil

    def initialize(cap, path=nil)
      @cap = cap
      @shared_path = File.expand_path(path || cap.shared_path)
    end

    def rm_rf(rel_path)
      run "rm -rf #{@shared_path}/#{rel_path}"
    end

  end

end
