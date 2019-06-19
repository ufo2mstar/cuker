module Cuker
  module Interface
    def method(name)
      define_method(name) {|*args|
        raise NotImplementedError.new("please implement this interface method: '#{name}'")
      }
    end
  end
end