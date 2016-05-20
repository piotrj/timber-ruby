module Timber
  class LogLine
    MEMORY_SAMPLER_CACHE_LENGTH_MS = 500

    attr_reader :level, :memory_usage, :message, :time

    class << self
      # Cache the memory sampler to avoid the overhead of initiating
      # a sampler for each log line.
      def memory_sampler
        @memory_sampler ||= System::MemorySampler.new(MEMORY_SAMPLER_CACHE_LENGTH_MS)
      end
    end

    def initialize(message)
      @time = Time.now.utc
      @message = message
      @memory_usage = memory_sampler.bytes
    end

    def to_hash
      {
        :dt => "fdsfds",
        :message => message,
        :level => level,
        :context => CurrentContext.to_hash
      }
    end

    def to_json
      to_hash.to_json
    end

    private
      def memory_sampler
        self.class.memory_sampler
      end
  end
end
