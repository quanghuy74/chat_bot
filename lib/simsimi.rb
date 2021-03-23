class Simsimi
require "net/http"
require "uri"
require "json"

  def self.mess mess
    uri = URI.parse("https://wsapi.simsimi.com/190410/talk")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["X-Api-Key"] = "Rz6CicoduYZWSEL8DRp6dLAqbr8j_53KjB68MGWc"
    request.body = JSON.dump({
      "utext" = "#{messl}"
      "lang" => "vi"
    })
    req_options = {use ssl: uri.scheme = "https"}
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
      res= JSON.parse response.body
      res["atext"]
  end
end
