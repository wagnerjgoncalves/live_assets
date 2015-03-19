require "live_assets/engine"
require "thread"
require "listen"

module LiveAssets
  mattr_reader :subscribers
  @@subscribers = []

  def self.subscribe(subscriber)
    subscribers << subscriber
  end

  def self.unsubscribe(subscriber)
    subscribers.delete(subscriber)
  end

  def self.start_listener(event, directories)
    Thread.new do
      listener = Listen.to(*directories) do |modified, added, removed|
        puts "modified: #{modified}"
        puts "added: #{added}"
        puts "removed: #{removed}"

        subscribers.each { |s| s << event }
      end

      listener.start
    end
  end

  def self.start_timer(event, time)
    Thread.new do
      while true
        subscribers.each { |s| s << event }
        sleep(time)
      end
    end
  end
end

module LiveAssets
  autoload :SSESubscriber, "live_assets/sse_subscriber"
end
