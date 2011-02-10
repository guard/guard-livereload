require 'spec_helper'

describe Guard::LiveReload do
  subject { Guard::LiveReload.new }

  describe 'options' do
    describe 'api_version' do
      it "should be == '1.5' by default" do
        subject = Guard::LiveReload.new([])
        subject.options[:api_version].should == '1.5'
      end

      it "should be set to '1.3'" do
        subject = Guard::LiveReload.new([], { :api_version => '1.3' })
        subject.options[:api_version].should == '1.3'
      end
    end

    describe 'host' do
      it "should be '0.0.0.0' by default" do
        subject = Guard::LiveReload.new([])
        subject.options[:host].should == '0.0.0.0'
      end

      it "should be set to '127.3.3.1'" do
        subject = Guard::LiveReload.new([], { :host => '127.3.3.1' })
        subject.options[:host].should == '127.3.3.1'
      end
    end

    describe 'port' do
      it "should be '35729' by default" do
        subject = Guard::LiveReload.new([])
        subject.options[:port].should == '35729'
      end

      it "should be set to '12345'" do
        subject = Guard::LiveReload.new([], { :port => '12345' })
        subject.options[:port].should == '12345'
      end
    end

    describe 'apply_js_live' do
      it "should be true by default" do
        subject = Guard::LiveReload.new([])
        subject.options[:apply_js_live].should be_true
      end

      it "should be set to false" do
        subject = Guard::LiveReload.new([], { :apply_js_live => false })
        subject.options[:apply_js_live].should be_false
      end
    end

    describe 'apply_css_live' do
      it "should be true by default" do
        subject = Guard::LiveReload.new([])
        subject.options[:apply_css_live].should be_true
      end

      it "should be set to false" do
        subject = Guard::LiveReload.new([], { :apply_css_live => false })
        subject.options[:apply_css_live].should be_false
      end
    end
  end

  describe "start" do
    it "should create reactor with default options" do
      subject = Guard::LiveReload.new([])
      Guard::LiveReload::Reactor.should_receive(:new).with(
        :api_version    => '1.5',
        :host           => '0.0.0.0',
        :port           => '35729',
        :apply_css_live => true,
        :apply_js_live  => true
      )
      subject.start
    end

    it "should create reactor with given options" do
      subject = Guard::LiveReload.new([], { :api_version => '1.3', :host => '127.3.3.1', :port => '12345', :apply_js_live => false, :apply_css_live => false })
      Guard::LiveReload::Reactor.should_receive(:new).with(
        :api_version    => '1.3',
        :host           => '127.3.3.1',
        :port           => '12345',
        :apply_css_live => false,
        :apply_js_live  => false
      )
      subject.start
    end
  end

  describe "stop" do
    it "should stop the reactor" do
      reactor = mock(Guard::LiveReload::Reactor)
      subject.stub(:reactor).and_return(reactor)
      reactor.should_receive(:stop)
      subject.stop
    end
  end

  describe "run_on_change" do
    it "should reload browser" do
      reactor = mock(Guard::LiveReload::Reactor)
      subject.stub(:reactor).and_return(reactor)
      reactor.should_receive(:reload_browser).with(['foo'])
      subject.run_on_change(['foo'])
    end
  end
end
