require 'spec_helper'

describe Giraft::Coordinator do
  let(:state) { double('Giraft::State') }
  let(:request_vote_options) { { term: 1, candidate_id: 1, last_log_index: 1, last_log_term: 1 } }
  let(:request) { Giraft::RequestVote.new(request_vote_options) }
  let(:coordinator) { Giraft::Coordinator.new(state, request) }

  it 'picks the right coordinator' do
    coordinator_klass = coordinator.coordinator_for_request(request)
    expect(coordinator_klass).to eq(Giraft::RequestVoteCoordinator)
  end
end
