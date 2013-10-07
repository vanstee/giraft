module Giraft
  class RequestVote
    attr_accessor :term, :candidate_id, :last_log_index, :last_log_term

    def initialize(options = {})
      self.term = options.fetch(:term)
      self.candidate_id = options.fetch(:candidate_id)
      self.last_log_index = options.fetch(:last_log_index)
      self.last_log_term = options.fetch(:last_log_term)
    end
  end
end
