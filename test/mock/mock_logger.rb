require 'logger'

class MockLogger < Logger
  attr_reader :messages

  def initialize
    @messages = []
  end

  def add(severity, message = nil, progname = nil, &block)
    @messages << [severity, message, progname, block]
  end
end
