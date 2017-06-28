require 'csv'

class StreamingController < ApplicationController
  def download
    # Tell Rack to stream the content
    headers.delete("Content-Length")

    # Don't cache anything from this generated endpoint
    headers["Cache-Control"] ||= "no-cache"

    # Set an Enumerator as the body
    self.response_body = body

    # Set the status to success
    response.status = 200
  end

  private

  def body
    Enumerator.new do |yielder|
      20.times do |num|
        sleep 0.05
        yielder << CSV.generate_line([num, "yay"])
      end
    end
  end
end
