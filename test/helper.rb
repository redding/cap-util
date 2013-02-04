# this file is automatically required in when you require 'assert' in your tests
# put test helpers here
ENV['CAPUTIL_SILENCE_SAY'] = 'yes'

# add root dir to the load path
$LOAD_PATH.unshift(File.expand_path("../..", __FILE__))

require 'cap-util'
require 'cap-util/fake_cap'

module TestHelpers

  class AnCapUtil
    include CapUtil

    def initialize(cap)
      @cap = cap
    end

  end

end
