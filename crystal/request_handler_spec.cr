require "spec"
require "http/server"
require "http/client"
require "./request_handler"

describe "handle_request" do
  it "returns a JSON response" do
    # Create a mock request
    request = HTTP::Request.new("http://localhost:8080", "GET", headers: HTTP::Headers{"Accept" => "application/json"})

    # Create a mock request context
    io = IO::Memory.new
    response = HTTP::Server::Response.new(io)
    context = HTTP::Server::Context.new(request, response)

    # Call the handler
    handle_request(context)
    response.close

    context.response.status_code.should eq 200
    context.response.headers["Content-Type"].should eq "application/json"
    io.rewind
    io.to_s.should eq "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: 41\r\n\r\n{\"hello\":\"World\", \"from\": \"d17d9e6f8396\"}"
  end
end
