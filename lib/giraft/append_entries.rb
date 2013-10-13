module Giraft
  class AppendEntries
    attr_accessor :term, :leader_id, :prev_log_index, :prev_log_term, :entries,
      :leader_commit

    def initialize(options = {})
      self.term = options.fetch(:term)
      self.leader_id = options.fetch(:leader_id)
      self.prev_log_index = options.fetch(:prev_log_index)
      self.prev_log_term = options.fetch(:prev_log_term)
      self.entries = options.fetch(:entries, [])
      self.leader_commit = options.fetch(:leader_commit)
    end
  end
end
