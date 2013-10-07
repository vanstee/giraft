module Giraft
  class RequestVoteResponse
  end

  class RequestVoteCoordinator
    attr_accessor :state, :request_vote

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

    def higher_term?
      request_vote.term > state.current_term
    end

    def current_term?
      request_vote.term == state.current_term
    end

    def lower_term?
      request_vote.term < state.current_term
    end
  end
end
