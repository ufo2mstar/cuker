module Cuker
  module Interface
    def method(name)
      define_method(name) {|*args|
        raise NotImplementedError.new("implemented interface method: '#{name}'")
      }
    end
  end
end