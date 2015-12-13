require 'cap-util'

module TestHelpers

  class ACapUtil
    include CapUtil

    def initialize(cap)
      @cap = cap
    end

  end

end
