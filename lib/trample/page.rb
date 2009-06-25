module Trample
  class Page
    attr_reader :request_method, :headers

    def initialize(request_method, url, *args)
      @request_method = request_method
      @url            = url

      parameters = args.pop
      if parameters.respond_to?(:call)
        if options = args.shift
          @headers = options.delete(:headers) || options.delete('headers')
        end
      elsif parameters
        @headers = parameters.delete(:headers) || parameters.delete('headers') || {}
      end
      @headers ||= {}
      @parameters     = parameters
    end

    def parameters
      proc_params? ? @parameters.call : @parameters
    end

    def ==(other)
      other.is_a?(Page) && 
        other.request_method == request_method &&
          other.url == url
    end

    def url
      proc_params? ? interpolated_url : @url
    end
    
    protected
      def proc_params?
        @parameters.respond_to?(:call)
      end

      def interpolated_url
        params = parameters # cache called proc
        url    = @url.dup
        url.scan(/\:\w+/).each do |m|
          url.gsub!(m, params[m.gsub(/:/, '').to_sym].to_s)
        end
        url
      end
  end
end
