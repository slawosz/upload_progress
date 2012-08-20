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

# proudly stolen from https://github.com/rails/rails/blob/9e0b3fc7cfba43af55377488f991348e2de24515/activesupport/lib/active_support/inflector/methods.rb#L213
def constantize(constant_string)
  names = constant_string.split('::')
  names.shift if names.empty? || names.first.empty?

  constant = Object
  names.each do |name|
    constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
  end
  constant
end

require_relative '../lib/upload_progress.rb'
require 'rspec'



