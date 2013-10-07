require 'giraft/log_entry'

module Giraft
  class Log
    attr_accessor :entries

    def initialize(entries = [])
      self.entries = entries
    end

    def find(index, term)
      entry = self.entries[index]
      entry if entry.term == term
    end

    def overwrite(new_entries)
      delete_conflicts(new_entries)
      append(new_entries)
    end

    def delete_conflicts(new_entries)
      first_term = new_entries.first.term
      conflict_index = entries.index { |entry| entry.term == first_term }
      index_range = Range.new(0, conflict_index, true)
      self.entries = entries[index_range]
    end

    def append(new_entries)
      self.entries += new_entries
    end

    def commit(index_range)
      entries[index_range].each(&:commit)
    end

    def ==(log)
      entries == log.entries
    end
  end
end
