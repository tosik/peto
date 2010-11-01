
module Peto
  module RailsControllerTestHelper
    def peto_post(procedure, args)
      post :index, {:procedure=>procedure.to_s, :args=>args}
    end

    def decoded_response
      @decoded_response ||= ActiveSupport::JSON.decode(@response.body)
    end

    def assert_peto_response(except)
      assert_equal decoded_response["args"], except
    end
  end
end


