require 'spec_helper'

describe Giraft::AppendEntriesCoordinator do
  let(:state) { double('Giraft::State') }
  let(:append_entries) { double('Giraft::AppendEntries') }
  let(:response) { Giraft::AppendEntriesResponse.new }
  let(:coordinator) { Giraft::AppendEntriesCoordinator.new(state, append_entries) }

  it 'applies the entires if they are accepted' do
    coordinator.stub(:accept_entries?) { true }

    expect(coordinator).to receive(:apply_entries)

    coordinator.handle_request
  end

  it 'returns a response if the entries are accepted' do
    coordinator.stub(:accept_entries?) { true }
    coordinator.stub(:apply_entries)
    coordinator.stub(:response) { response }

    expect(coordinator.handle_request).to eq(response)
  end

  it 'does not return a response if the entries are not accepted' do
    coordinator.stub(:accept_entries?) { false}

    expect(coordinator.handle_request).to eq(nil)
  end

  it 'can apply entries by overwriting and then commiting' do
    coordinator.stub(:with_state_updates).and_yield

    expect(coordinator).to receive(:overwrite_entries)
    expect(coordinator).to receive(:commit_entries)

    coordinator.apply_entries
  end

  it 'updates state if entries are accepted' do
    append_entries.stub(:term) { 2 }
    append_entries.stub(:leader_commit) { 1 }

    expect(state).to receive(:current_term=).with(2)
    expect(state).to receive(:commit_index=).with(1)
    expect(state).to receive(:last_applied=).with(1)

    coordinator.with_state_updates { }
  end

  it 'can overwrite conflicting entries' do
    log = Giraft::Log.new
    state.stub(:log) { log }
    append_entries.stub(:entries) { [] }

    expect(log).to receive(:overwrite).with([])

    coordinator.overwrite_entries
  end

  it 'can commit a range of entries' do
    log = Giraft::Log.new
    state.stub(:log) { log }
    coordinator.stub(:commit_index_range) { 2..4 }

    expect(log).to receive(:commit).with(2..4)

    coordinator.commit_entries
  end

  it 'calculates the range of entries to be committed' do
    state.stub(:last_applied) { 2 }
    state.stub(:commit_index) { 4 }

    expect(coordinator.commit_index_range).to eq(3..4)
  end

  it 'knows when the entries should not be accepted' do
    coordinator.stub(:lower_term?) { false }
    coordinator.stub(:prev_log_matches?) { true }

    expect(coordinator.accept_entries?).to eq(true)
  end

  it 'can check if the previous log entry matches' do
    log = Giraft::Log.new
    state.stub(:log) { log }
    append_entries.stub(:prev_log_index) { 1 }
    append_entries.stub(:prev_log_term) { 2 }
    entry = double('Giraft::LogEntry')

    log.stub(:find).with(1, 2) { entry }
  end
end
