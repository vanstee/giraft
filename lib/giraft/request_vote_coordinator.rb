require 'giraft/response_coordinator'

module Giraft
  class RequestVoteResponse
  end

  class RequestVoteCoordinator
    include ResponseCoordinator

    attr_accessor :state, :request_vote
    alias_method :request, :request_vote

    def initialize(state, request_vote)
      self.state = state
      self.request_vote = request_vote
    end

    def handle_request
      if accept_vote?
        apply_vote
        response
      end
    end

    def apply_vote
      state.current_term = request_vote.term
      state.voted_for = request_vote.candidate_id
    end

    def response
      RequestVoteResponse.new
    end

    def accept_vote?
      higher_term? || vote_available? || identical_vote?
    end

    def vote_available?
      current_term? && empty_vote?
    end

    def identical_vote?
      state.voted_for == request_vote.candidate_id
    end

    def empty_vote?
      state.voted_for.nil?
    end
  end
end
