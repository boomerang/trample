module Trample
  class Runner
    include Logging

    attr_reader :config, :threads

    def initialize(config)
      @config  = config
      @threads = []
    end

    def trample
      start_time = Time.now
      logger.info "Starting trample at #{start_time}..."

      config.concurrency.times do
        thread = Thread.new(@config) do |c|
          Session.new(c).trample
        end
        threads << thread
      end

      threads.each { |t| t.join }

      logger.info "Trample completed at #{Time.now}, duration #{Time.now.to_f - start_time.to_f}s ..."
    end
  end
end

