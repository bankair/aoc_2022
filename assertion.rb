# frozen_string_literal: true

# Micro test framework
class Assertion
  attr_reader :expected

  def initialize(expected)
    @expected = expected
  end

  class MismatchError < StandardError; end

  def for
    raise 'Missing block' unless block_given?

    actual = yield
    raise MismatchError, "Expected #{expected.inspect}, got #{actual.inspect}" unless expected == actual
  end
end

def should_return(expected)
  Assertion.new(expected)
end
