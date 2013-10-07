require 'giraft/request_vote_coordinator'
require 'giraft/state'

require 'forwardable'

module Giraft
  class Node
    extend Forwardable

    attr_accessor :state

    def_delegators :state, :follower?, :candidate?, :leader?

    def initialize(state = nil)
      self.state = state || default_state
    end

    def request_vote(request)
      with_coordinator(request) do |coordinator|
        coordinator.handle_request
      end
    end

    def with_coordinator(request)
      yield request_vote_coordinator(request)
    end

    def request_vote_coordinator(request)
      RequestVoteCoordinator.new(state, request)
    end

    def default_state
      State.new(:follower)
    end
  end
end
