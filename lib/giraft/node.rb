require 'giraft/append_entries'
require 'giraft/append_entries_coordinator'
require 'giraft/request_vote'
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

    [:request_vote, :append_entries].each do |request_name|
      define_method(request_name) do |request|
        with_coordinator(request, &:handle_request)
      end
    end

    def with_coordinator(request)
      yield coordinator(request)
    end

    def coordinator(request)
      case request
      when RequestVote
        RequestVoteCoordinator.new(state, request)
      when AppendEntries
        AppendEntriesCoordinator.new(state, request)
      end
    end

    def default_state
      State.new(:follower)
    end
  end
end
