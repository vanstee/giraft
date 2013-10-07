require 'spec_helper'

describe Giraft::RequestVoteCoordinator do
  let(:state) { double('Giraft::State') }
  let(:request_vote) { double('Giraft::RequestVote') }
  let(:response) { Giraft::RequestVoteResponse.new }
  let(:coordinator) { Giraft::RequestVoteCoordinator.new(state, request_vote) }

  it 'records the vote if the vote is accepted' do
    coordinator.stub(:accept_vote?) { true }

    expect(coordinator).to receive(:apply_vote)

    coordinator.handle_request
  end

  it 'copies request for votes over to the local state when accepting a vote' do
    request_vote.stub(:term) { 1 }
    request_vote.stub(:candidate_id) { 2 }

    expect(state).to receive(:current_term=).with(1)
    expect(state).to receive(:voted_for=).with(2)

    coordinator.apply_vote
  end

  it 'returns a response if the vote is accepted' do
    coordinator.stub(:accept_vote?) { true }
    coordinator.stub(:apply_vote)
    coordinator.stub(:response) { response }

    expect(coordinator.handle_request).to eq(response)
  end

  it 'does not return a response if the vote is not accepted' do
    coordinator.stub(:accept_vote?) { false }

    expect(coordinator.handle_request).to eq(nil)
  end

  it 'accepts request votes with higher terms and when we have not already voted' do
    coordinator.stub(:higher_term?) { false }
    coordinator.stub(:vote_available?) { true }

    expect(coordinator.accept_vote?).to be_true
  end

  it 'knows when a vote is still available' do
    coordinator.stub(:current_term?) { true }
    coordinator.stub(:empty_vote?) { true }

    expect(coordinator.vote_available?).to be_true
  end

  it 'can identify a vote that has already been made' do
    state.stub(:voted_for) { 1 }
    request_vote.stub(:candidate_id) { 1 }

    expect(coordinator.identical_vote?).to be_true
  end

  it 'knows if a vote has not yet been accepted' do
    state.stub(:voted_for) { nil }

    expect(coordinator.empty_vote?).to be_true
  end
end
