class LiveAssetsController < ActionController::Base
  include ActionController::Live

  def hello
    while true
      response.stream.write "Hello Word\n"
      sleep 1
    end
  rescue IOError
    response.stream.close
  end

  def sse
    response.headers["Cache-Control"] = "no-cache"
    response.headers["Content-Type"]  = "text/event-stream"

    sse = LiveAssets::SSESubscriber.new
    sse.each { |msg| response.stream.write msg }
  rescue IOError
    sse.close
    response.stream.close
  end
end
