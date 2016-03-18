require 'guard/compat/test/helper'

require 'timecop'

RSpec.describe Guard::LiveReload::GuaranteedSleep do
  let(:start_time) { Time.local(2006, 3, 18, 2, 0) }

  let(:implementation) { Kernel }

  around do |example|
    Timecop.freeze(start_time) do
      example.run
    end
  end

  describe '.sleep' do
    before do
      @interruptions = interruptions
      allow(implementation).to receive(:sleep) do |time|
        t = (@interruptions > 0 ? (time.to_f / 2) : time)
        @interruptions -= 1
        Timecop.travel(Time.now + t)
        t
      end
    end

    context 'with 0' do
      let(:interruptions) { 0 }

      it 'never sleeps' do
        subject.sleep(0)
        expect(implementation).to_not receive(:sleep)
        expect(Time.now).to be_within(0.05).of(start_time)
      end
    end

    context 'when never interrupted' do
      let(:interruptions) { 0 }

      it 'waits before reloading the browser' do
        subject.sleep(5)
        expect(Time.now).to be_within(0.1).of(start_time + 5)
      end
    end

    context 'when interrupted once' do
      let(:interruptions) { 1 }

      it 'waits before reloading the browser' do
        subject.sleep(5)
        expect(Time.now).to be_within(0.1).of(start_time + 5)
      end
    end

    context 'when interrupted many times' do
      let(:interruptions) { 3 }

      it 'waits before reloading the browser' do
        subject.sleep(5)
        expect(Time.now).to be_within(0.1).of(start_time + 5)
      end
    end
  end
end
