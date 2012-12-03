require 'nexmo'

nexmo = Nexmo::Client.new('NO', 'NO')

response = nexmo.send_message({
  from: '16477252253',
    to: 'NUM',
  text: 'ohhhcool'
})

if response.success?
  puts "Sent message: #{response.message_id}"
elsif response.failure?
  raise response.error
end