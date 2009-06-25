module Trample
  class Configuration
    attr_reader :pages

    def initialize(&block)
      @pages = []
      instance_eval(&block)
    end

    def concurrency(*value)
      @concurrency = value.first unless value.empty?
      @concurrency
    end

    def iterations(*value)
      @iterations = value.first unless value.empty?
      @iterations
    end

    def get(url, *args, &block)
      args << block if block_given?

      @pages << Page.new(:get, url, *args)
    end

    def post(url, *args, &block)
      args << block if block_given?

      @pages << Page.new(:post, url, *args)
    end

    def login
      if block_given?
        yield
        @login = pages.pop
      end

      @login
    end

    def ==(other)
      other.is_a?(Configuration) &&
        other.pages == pages &&
        other.concurrency == concurrency &&
        other.iterations  == iterations
    end
  end
end
