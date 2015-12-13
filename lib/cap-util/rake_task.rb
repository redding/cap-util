require 'cap-util'

module CapUtil

  # This defines a base utiltiy for building tasks that run rake tasks.  Pass
  # in the rake task name and this will make sure it is run with the appropriate
  # settings and environment

  class RakeTask
    include CapUtil

    attr_reader :cmd

    def initialize(cap, task, opts = nil)
      @cap = cap

      opts        ||= {}
      opts[:root] ||= :current_path
      opts[:rake] ||= "bundle exec rake"
      opts[:env]  ||= ""
      rakefile_root = cap.send(opts[:root])

      @cmd = "cd #{rakefile_root} && #{opts[:env]} #{opts[:rake]} #{task}"
    end

    def run; super(@cmd); end

  end

end
