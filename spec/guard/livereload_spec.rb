require 'spec_helper'

describe Guard::LiveReload do
  subject { Guard::LiveReload.new }
  
  describe "start" do
    it "should set reactor with default options" do
      Guard::LiveReload::Reactor.should_receive(:new).with(
        :api_version    => '1.4',
        :host           => '0.0.0.0',
        :port           => '35729',
        :apply_css_live => true,
        :apply_js_live  => true
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