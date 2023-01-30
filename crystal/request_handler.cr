require "json"

class Greetings
  include JSON::Serializable

  property greetings : Array(Greeting)
end

class Greeting
  include JSON::Serializable

  property greeting : String
  property language : String
end

def handle_request(context)
  context.response.content_type = "application/json"

  # Load the hello-world.json file
  file = File.read("../hello-world.json")
  data = JSON.parse(file)

  random_greeting = data[Random.rand(0..data.size - 1)]

  # Return the selected greeting and language in the response
  context.response.print %({"greeting": "#{random_greeting["greeting"]}", "language": "#{random_greeting["language"]}", "from": "#{System.hostname}", "implementation": "Crystal"})

  puts "#{context.request.method} #{context.request.hostname} #{context.request.path}"
end
