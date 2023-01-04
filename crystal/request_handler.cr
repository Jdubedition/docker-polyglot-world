# In a separate file, such as request_handler.cr
def handle_request(context)
  context.response.content_type = "application/json"
  context.response.print %({"hello":"World", "from": "#{System.hostname}"})
  puts "#{context.request.method} #{context.request.hostname} #{context.request.path}"
end
