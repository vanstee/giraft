module Giraft
  class LogEntry
    attr_accessor :term

    def initialize(term)
      self.term = term
    end

    def commit
    end

    def ==(log_entry)
      self.term == log_entry.term
    end
  end
end
