require 'spec_helper'

describe Guard::LiveReload do
  subject { Guard::LiveReload.new }

  describe "#initialize" do
    describe ":host option" do
      it "is '0.0.0.0' by default" do
        subject = Guard::LiveReload.new([])
        subject.options[:host].should == '0.0.0.0'
      end

      it "can be set to '127.3.3.1'" do
        subject = Guard::LiveReload.new([], { :host => '127.3.3.1' })
        subject.options[:host].should == '127.3.3.1'
      end
    end

    describe ":apply_css_live option" do
      it "is true by default" do
        subject = Guard::LiveReload.new([])
        subject.options[:apply_css_live].should be_true
      end

      it "can be set to false" do
        subject = Guard::LiveReload.new([], { :apply_css_live => false })
        subject.options[:apply_css_live].should be_false
      end
    end

    describe ":override_url option" do
      it "is false by default" do
        subject = Guard::LiveReload.new([])
        subject.options[:override_url].should be_false
      end

      it "can be set to false" do
        subject = Guard::LiveReload.new([], { :override_url => true })
        subject.options[:override_url].should be_true
      end
    end

    describe ":grace_period option" do
      it "is 0 by default" do
        subject = Guard::LiveReload.new([])
        subject.options[:grace_period].should == 0
      end

      it "can be set to 0.5" do
        subject = Guard::LiveReload.new([], { :grace_period => 0.5 })
        subject.options[:grace_period].should == 0.5
      end
    end
  end

  describe "#start" do
    it "creates reactor with default options" do
      subject = Guard::LiveReload.new([])
      Guard::LiveReload::Reactor.should_receive(:new).with(
        :host           => '0.0.0.0',
        :apply_css_live => true,
        :override_url   => false,
        :grace_period   => 0
      )
      subject.start
    end

    it "creates reactor with given options" do
      subject = Guard::LiveReload.new([], { :api_version => '1.3', :host => '127.3.3.1', :apply_css_live => false, :override_url => true, :grace_period => 1 })
      Guard::LiveReload::Reactor.should_receive(:new).with(
        :api_version    => '1.3',
        :host           => '127.3.3.1',
        :apply_css_live => false,
        :override_url   => true,
        :grace_period   => 1
      )
      subject.start
    end
  end

  describe "#stop" do
    it "stops the reactor" do
      reactor = mock(Guard::LiveReload::Reactor)
      subject.stub(:reactor).and_return(reactor)
      reactor.should_receive(:stop)
      subject.stop
    end
  end

  describe "#run_on_changes" do
    it "reloads browser" do
      reactor = mock(Guard::LiveReload::Reactor)
      subject.stub(:reactor).and_return(reactor)
      reactor.should_receive(:reload_browser).with(['foo'])
      subject.run_on_changes(['foo'])
    end

    it "can wait 0.5 seconds before reloading the browser" do
      reactor = mock(Guard::LiveReload::Reactor)
      subject.stub(:reactor).and_return(reactor)
      reactor.should_receive(:reload_browser).with(['foo'])
      subject.should_receive(:sleep).with(0.5)
      subject.options[:grace_period] = 0.5
      subject.run_on_changes(['foo'])
    end
  end
end
