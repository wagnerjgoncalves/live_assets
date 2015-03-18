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
    response.headers["Content-Type"] = "text/event-stream"

    while true
      response.stream.write "event: reloadCSS\ndata: { time: #{Time.now} }\n\n"
      sleep 5
    end
  rescue IOError
    response.stream.close
  end
end
