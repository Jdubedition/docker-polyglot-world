require "http/server"
require "system"

server = HTTP::Server.new do |context|
  context.response.content_type = "json/application"
  context.response.print %({"hello":"World", "from": "#{System.hostname}"})
  puts "#{context.request.method} #{context.request.hostname} #{context.request.path}"
end

address = server.bind_tcp "0.0.0.0", 8080
puts "Listening on http://#{address}"
server.listen
