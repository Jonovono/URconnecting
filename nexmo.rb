require 'nexmo'

nexmo = Nexmo::Client.new('404e7d57', '721423dd')

response = nexmo.send_message({
  from: '16477252253',
    to: '13065377760',
  text: 'ohhhcool'
})

if response.success?
  puts "Sent message: #{response.message_id}"
elsif response.failure?
  raise response.error
end

447525856424
013065377760