require 'giraft/response_coordinator'

module Giraft
  class AppendEntriesResponse
  end

  class AppendEntriesCoordinator
    include ResponseCoordinator

    attr_accessor :state, :append_entries
    alias_method :request, :append_entries

    def initialize(state, append_entries)
      self.state = state
      self.append_entries = append_entries
    end

    def handle_request
      if accept_entries?
        apply_entries
        response
      end
    end

    def response
      AppendEntriesResponse.new
    end

    def apply_entries
      with_state_updates do
        overwrite_entries
        commit_entries
      end
    end

    def with_state_updates
      state.current_term = append_entries.term
      state.commit_index = append_entries.leader_commit
      yield
      state.last_applied = append_entries.leader_commit
    end

    def overwrite_entries
      state.log.overwrite(append_entries.entries)
    end

    def commit_entries
      state.log.commit(commit_index_range)
    end

    def commit_index_range
      Range.new(state.last_applied + 1, state.commit_index)
    end

    def accept_entries?
      !lower_term? && prev_log_matches?
    end

    def prev_log_matches?
      state.log.find(append_entries.prev_log_index, append_entries.prev_log_term)
    end
  end
end
