require 'spec_helper'

describe Giraft::Node do
  let(:node) { Giraft::Node.new }
  let(:request_vote_options) { { term: 1, candidate_id: 1, last_log_index: 1, last_log_term: 1 } }
  let(:request) { Giraft::RequestVote.new(request_vote_options) }
  let(:coordinator) { double('Giraft::RequestVoteCoordinator') }

  it 'defaults to a follower' do
    expect(node).to be_follower
  end

  it 'asks a coordinator for a response to a specific request' do
    expect(node).to receive(:with_coordinator).and_yield(coordinator)
    expect(coordinator).to receive(:handle_request)

    node.request_vote(request)
  end

  it 'calls the block with a coordinator object' do
    expect(node).to receive(:with_coordinator).and_yield(coordinator)

    expect(node.with_coordinator(request) { |c| c }).to eq(coordinator)
  end

  it 'creates a coordinator with the state of the node and the request' do
    expect(Giraft::RequestVoteCoordinator).to receive(:new).with(node.state, request)

    node.coordinator(request)
  end
end
