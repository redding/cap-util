require 'cap-util'

module CapUtil
  class GitBranch
    include CapUtil

    def self.current(action=:run)
      git_cmd = "git symbolic-ref HEAD"
      if action == :run
        say "Fetching #{color "current git branch", :bold, :cyan} from HEAD"
        (r = run_locally(git_cmd)).success? ? r.stdout.split('/').last.strip : halt
      elsif action == :cmd
        git_cmd
      end
    end

  end
end
