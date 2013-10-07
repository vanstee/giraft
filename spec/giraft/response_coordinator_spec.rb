require 'spec_helper'

describe Giraft::ResponseCoordinator do
  let(:coordinator_class) do
    Class.new do
      include Giraft::ResponseCoordinator

      attr_accessor :state, :request

      def initialize(state, request)
        self.state = state
        self.request = request
      end
    end
  end

  let(:state) { double('Giraft::State') }
  let(:request) { double('Giraft::Request') }
  let(:coordinator) { coordinator_class.new(state, request) }

  it 'knows when the request has a higher term' do
    state.stub(:current_term) { 1 }
    request.stub(:term) { 2 }

    expect(coordinator.higher_term?).to be_true
  end

  it 'knows when the request has the same term' do
    state.stub(:current_term) { 1 }
    request.stub(:term) { 1 }

    expect(coordinator.current_term?).to be_true
  end

  it 'knows when the request has a lower term' do
    state.stub(:current_term) { 2 }
    request.stub(:term) { 1 }

    expect(coordinator.lower_term?).to be_true
  end
end
