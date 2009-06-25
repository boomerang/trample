require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rr'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'trample'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit unless include?(RR::Adapters::TestUnit)

  protected
  def trample(config)
    Trample::Cli.new.start(config)
  end

  def mock_get(url, opts={})
    return_cookies = opts.delete(:return_cookies) || {}
    opt_times = opts.delete(:times) || 1
    opts[:cookies] ||= {}

    mock(RestClient).get(url, opts).times(opt_times) do
      response = RestClient::Response.new("", stub!)
      stub(response).cookies { return_cookies }
      stub(response).code { 200 }
    end
  end

  def mock_post(url, opts={})
    payload = opts.delete(:payload)
    return_cookies = opts.delete(:return_cookies) || {}
    opt_times = opts.delete(:times) || 1
    opts[:cookies] ||= {}

    mock(RestClient).post(url, payload, opts).times(opt_times) do
      response = RestClient::Response.new("", stub!)
      stub(response).cookies { return_cookies }
      stub(response).code { 200 }
    end
  end

  def stub_get(url, opts = {})
    return_cookies = opts.delete(:return_cookies) || {}
    opt_times = opts.delete(:times) || 1
    opts[:cookies] ||= {}

    stub(RestClient).get(url, opts).times(opt_times) do
      response = RestClient::Response.new("", stub!)
      stub(response).cookies { return_cookies }
      stub(response).code { 200 }
    end
  end
end

