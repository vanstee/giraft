require 'forwardable'

module Giraft
  class State
    extend Forwardable

    attr_accessor :role

    def_delegators :persistent_state, :current_term, :voted_for, :log
    def_delegators :volatile_state, :commit_index, :last_applied
    def_delegators :leader_state, :next_index, :match_index

    def initialize(role = :follower)
      self.role = role
      self.persistent_state = PersistentState.new
      self.volatile_state = VolatileState.new
      self.leader_state = LeaderState.new
    end

    private

    attr_accessor :persistent_state, :volatile_state, :leader_state
  end

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
