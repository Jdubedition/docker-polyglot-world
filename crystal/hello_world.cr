require "http/server"
require "./request_handler"

server = HTTP::Server.new do |context|
  handle_request(context)
end

address = server.bind_tcp "0.0.0.0", 8080
puts "Listening on http://#{address}"
server.listen
