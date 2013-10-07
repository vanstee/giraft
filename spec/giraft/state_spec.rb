require 'spec_helper'

describe Giraft::State do
  let(:state) { Giraft::State.new }

  it 'initializes role to follower' do
    expect(state.role).to eq(:follower)
  end

  context 'with initialization parameters' do
    let(:state) { Giraft::State.new(:leader) }

    it 'allows for initializing with a role' do
      expect(state.role).to eq(:leader)
    end
  end
end

describe Giraft::PersistentState do
  let(:persistent_state) { Giraft::PersistentState.new }

  it 'initializes current term to 0' do
    expect(persistent_state.current_term).to eq(0)
  end

  it 'initializes log to an empty array' do
    expect(persistent_state.log).to eq([])
  end
end

describe Giraft::VolatileState do
  let(:volatile_state) { Giraft::VolatileState.new }

  it 'initializes commit index to 0' do
    expect(volatile_state.commit_index).to eq(0)
  end

  it 'initializes last applied to 0' do
    expect(volatile_state.last_applied).to eq(0)
  end
end

describe Giraft::LeaderState do
  let(:leader_state) { Giraft::LeaderState.new }

  it 'initializes next index to an empty array' do
    expect(leader_state.next_index).to eq([])
  end

  it 'initializes match index to an empty array' do
    expect(leader_state.match_index).to eq([])
  end
end
