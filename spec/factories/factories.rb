# frozen_string_literal: true

# Helper methods
def random_string
  (0...8).map { rand(1..26).chr }.join
end

def random_integer
  (0...3).map { rand(1..26) }.join
end
