require "spec"
require "http/server"
require "http/client"
require "./request_handler"

describe "handle_request" do
  it "returns a JSON response" do
    # Load the hello-world.json file
    file = File.read("../hello-world.json")
    data = JSON.parse(file)

    # Create a mock request
    request = HTTP::Request.new("http://localhost:8080", "GET", headers: HTTP::Headers{"Accept" => "application/json"})

    # Create a mock request context
    io = IO::Memory.new
    response = HTTP::Server::Response.new(io)
    context = HTTP::Server::Context.new(request, response)

    # Call the handler
    handle_request(context)
    response.close

    # Get the response body
    response_body = io.to_s.split("\r\n\r\n", 2).last

    # Parse the response body
    response_body_json = JSON.parse(response_body)

    context.response.status_code.should eq 200
    context.response.headers["Content-Type"].should eq "application/json"
    data.to_s.should contain response_body_json["greeting"].to_s
    data.to_s.should contain response_body_json["language"].to_s
  end
end
