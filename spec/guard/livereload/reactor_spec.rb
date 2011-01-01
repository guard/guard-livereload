require 'spec_helper'

describe Guard::LiveReload::Reactor do
  let(:paths) { %w[stylesheets/layout.css stylesheets/style.css] }
  
  describe "#reload_browser(paths = [])" do
    it "should display a message" do
      Guard::UI.should_receive(:info).with("Reloading browser: stylesheets/layout.css stylesheets/style.css")
      new_live_reactor.reload_browser(paths)
    end
    
    it "each web socket should receive send with data containing default options for each path modified" do
      reactor = new_live_reactor
      paths.each do |path|
        reactor.web_sockets.each do |ws|
          ws.should_receive(:send).with(['refresh', { :path => path, :apply_js_live => true, :apply_css_live => true }].to_json)
        end
      end
      reactor.reload_browser(paths)
    end
    
    it "each web socket should receive send with data containing custom options for each path modified" do
      reactor = new_live_reactor(:apply_css_live => false, :apply_js_live => false)
      paths.each do |path|
        reactor.web_sockets.each do |ws|
          ws.should_receive(:send).with(['refresh', { :path => path, :apply_js_live => false, :apply_css_live => false }].to_json)
        end
      end
      reactor.reload_browser(paths)
    end
  end
  
end

def new_live_reactor(options = {})
  Guard::LiveReload::Reactor.new({ :api_version => '1.5', :host => '0.0.0.0', :port => '35729', :apply_js_live => true, :apply_css_live => true }.merge(options))
end