module Giraft
  class PersistentState
    attr_accessor :current_term, :voted_for, :log

    def initialize
      self.current_term = 0
      self.log = []
    end
  end

  class VolatileState
    attr_accessor :commit_index, :last_applied

    def initialize
      self.commit_index = 0
      self.last_applied = 0
    end
  end

  class LeaderState
    attr_accessor :next_index, :match_index

    def initialize
      self.next_index = []
      self.match_index = []
    end
  end
end
