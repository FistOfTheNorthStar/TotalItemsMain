require "net/http"
require "uri"
require "json"

class SlackNotificationJob
  include Sidekiq::Job
  class SlackNotificationError < StandardError; end

  def perform(message)
    uri = URI(ENV["SLACK_WEBHOOK_URL"])
    if uri.host.nil? || uri.port.nil?
      raise(SlackNotificationError, "Invalid URI: Host or port is missing.")
    else
      http = Net::HTTP.new(uri.host || "", uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request.body = { text: message }.to_json
      http.request(request)
    end
  end
end
