require 'plivo'
include Plivo

AUTH_ID = "MAYZAWY2Y4NTG2NTM3OW"
AUTH_TOKEN = "MTUwMjNhZTI3Y2RhMmM4YzcwNmM3ZDhkZmI3OGNh"


p = RestAPI.new(AUTH_ID, AUTH_TOKEN)


# Send SMS
params = {'src' => '13069881525', 
           'dst' => '13065377760', 
           'text' => 'Hi, message from Plivo this is pretty cool ',
           'type' => 'sms',
        }
response = p.send_message(params)

