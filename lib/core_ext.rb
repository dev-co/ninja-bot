class Array
  def choice
    at(rand(size))
  end
end

module Enumerable
  class Enumerator
    def to_a
      []
    end
  end
end
