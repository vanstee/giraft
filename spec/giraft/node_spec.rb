require 'spec_helper'

describe Giraft::Node do
  let(:node) { Giraft::Node.new }
  let(:request) { double('Giraft::RequestVote') }
  let(:coordinator) { double('Giraft::RequestVoteCoordinator') }

  it 'defaults to a follower' do
    expect(node).to be_follower
  end

  it 'asks a coordinator for a response to a request vote call' do
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

    node.request_vote_coordinator(request)
  end
end
