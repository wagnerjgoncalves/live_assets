require "live_assets/engine"
require "thread"
require "listen"

module LiveAssets
  mattr_reader :subscribers
  @@subscribers = []
  @@mutex = Mutex.new

  def self.subscribe(subscriber)
    @@mutex.synchronize do
      subscribers << subscriber
    end
  end

  def self.unsubscribe(subscriber)
    @@mutex.synchronize do
      subscribers.delete(subscriber)
    end
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
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :SSESubscriber
  end
end
