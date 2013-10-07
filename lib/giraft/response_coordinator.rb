module Giraft
  module ResponseCoordinator
    def higher_term?
      request.term > state.current_term
    end

    def current_term?
      request.term == state.current_term
    end

    def lower_term?
      request.term < state.current_term
    end
  end
end
