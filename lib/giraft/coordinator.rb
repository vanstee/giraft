require 'delegate'

module Giraft
  class Coordinator < SimpleDelegator
    def initialize(state, request)
      coordinator = coordinator_for_request(request).new(state, request)
      super(coordinator)
    end

    def coordinator_for_request(request)
      case request
      when RequestVote   then RequestVoteCoordinator
      when AppendEntries then AppendEntriesCoordinator
      end
    end
  end
end
