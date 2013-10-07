require 'spec_helper'

describe Giraft::RequestVoteCoordinator do
  let(:state) { double('Giraft::State') }
  let(:request_vote) { double('Giraft::RequestVote') }
  let(:coordinator) { Giraft::RequestVoteCoordinator.new(state, request_vote) }

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

  it 'knows when the request has a higher term' do
    state.stub(:current_term) { 1 }
    request_vote.stub(:term) { 2 }

    expect(coordinator.higher_term?).to be_true
  end

  it 'knows when the request has the same term' do
    state.stub(:current_term) { 1 }
    request_vote.stub(:term) { 1 }

    expect(coordinator.current_term?).to be_true
  end

  it 'knows when the request has a lower term' do
    state.stub(:current_term) { 2 }
    request_vote.stub(:term) { 1 }

    expect(coordinator.lower_term?).to be_true
  end
end