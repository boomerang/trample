require 'test_helper'

class PageTest < Test::Unit::TestCase
  context "A page" do
    setup do
      @page = Trample::Page.new(:get, "http://google.com/", :username => "joetheuser")
    end

    should "have a request_method" do
      assert_equal :get, @page.request_method
    end

    should "have a url" do
      assert_equal "http://google.com/", @page.url
    end

    should "have request parameters" do
      assert_equal({:username => "joetheuser"}, @page.parameters)
    end

    should "be equal with the same request_method and url" do
      assert_equal Trample::Page.new(:get, "http://google.com"), Trample::Page.new(:get, "http://google.com")
    end

    should "not be equal with a different request_method or url" do
      assert_not_equal Trample::Page.new(:get, "http://google.com"), Trample::Page.new(:get, "http://google.com/asdf")
    end
  end

  context "with headers and explicit parameters" do
    setup do
      @page = Trample::Page.new(:get, 'http://google.com/:id', :headers => {:accepts => 'text/html'}, :id => 5)
    end
    should 'extract headers from parameters' do
      assert_equal({:accepts => 'text/html'}, @page.headers)
    end

    should 'omit the headers from the parameters' do
      assert_equal({:id => 5}, @page.parameters)
    end
  end

  context 'with headers and interpoloated parameters' do
    setup do
      @page = Trample::Page.new(:get, 'http://google.com/:id', {:headers => {:accepts => 'text/html'}}, lambda { {:id => 5}})
    end

    should 'extract headers from parameters' do
      assert_equal( {:accepts => 'text/html'}, @page.headers)
    end

    should 'interpolate parameters' do
      assert_equal( {:id => 5}, @page.parameters)
    end
  end

  context "Block-based request parameters for POST requests" do
    setup do
      @page = Trample::Page.new(:post, "http://google.com/:id", lambda { { :id => 1, :username => "joetheuser" } })
    end

    should "be resolved at call time" do
      assert_equal({:username => "joetheuser", :id => 1}, @page.parameters)
    end

    should "interpolate parameters into the url" do
      assert_equal "http://google.com/1", @page.url
    end
  end

  context "Block based parameters for GET requests" do
    setup do
      @page = Trample::Page.new(:get, "http://mysite.com/somethings/:id", lambda { {:id => 5} })
    end

    should "interpolate those parameters with the url string" do
      assert_equal "http://mysite.com/somethings/5", @page.url
    end

    should "interpolate a different parameter each time" do
      page = Trample::Page.new(:get, "http://mysite.com/somethings/:id", lambda { {:id => rand(1000)} })
      assert_not_equal page.url, page.url
    end
  end

  context "A page with port number and block based parameters" do
    setup do
      @page = Trample::Page.new(:get, "http://localhost:3000/somethings/:id", lambda { {:id => 1} })    
    end

    should "not interpolate the port" do
      assert_equal "http://localhost:3000/somethings/1", @page.url
    end
  end
end

