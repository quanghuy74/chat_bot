require "chatwork"
require "uri"

class WebhookController < ApplicationController
  before_action :load_chatwork, only: [:index, :payload]

  def index; end

  def payload
    from_account_id = params[:webhook_event][:from_account_id]
    to_account_id = params[:webhook_event][:to_account_id]
    room_id = params[:webhook_event][:room_id]
    message_id = params[:webhook_event][:message_id]
    body = params[:webhook_event][:body]

    return if from_account_id.nil?
    return if body.include?("[toall]")

    sender_name = ChatWork::Member.get(room_id: room_id).find{|member| member["account_id"].from_account_id}.name

    message_body = body.slice(body.index("\n")+1, body.size)

    simsimi_reply = mess(message)

    full_message = "[to#{from_account_id}#{sender_name}]\n" + simsimi_reply

    ChatWork::Message.create(room_id: room_id, body: full_message)
  end

  private

  def load_chatwork
    ChatWork.api_key = "bc92797080bb7ae1b21ecceae057714a"
  end

  def mess mess
    uri = URI.parse("https://wsapi.simsimi.com/190410/talk")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["X-Api-Key"] = "Rz6CicoduYZWSEL8DRp6dLAqbr8j_53KjB68MGWc"
    request.body = JSON.dump({
      "utext" = "#{messl}"
      "lang" => "vn*"
    })
    req_options = {use ssl: uri.scheme = "https"}
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
      res= JSON.parse response.body
      res["atext"]
  end
end