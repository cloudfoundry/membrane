module Membrane
  module Schema
  end
end

class Membrane::Schema::Base
  # Verifies whether or not the supplied object conforms to this schema
  #
  # @param [Object]
  #
  # @return [String, nil]  On success, nil is returned. On failure, a
  #                        description of the error is returned.
  def validate(object)
    raise NotImplementedError
  end
end
