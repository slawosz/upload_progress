module Thin
  class Connection
  end

  module Backends
    class TcpServer
    end
  end
end

class FakeManager
  def initialize(arg); end
  def save(arg); end
  def get; end
end

require_relative '../lib/upload_progress.rb'
require 'rspec'

