require 'cap-util'

module TestHelpers

  class AnCapUtil
    include CapUtil

    def initialize(cap)
      @cap = cap
    end

  end

end
