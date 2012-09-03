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

params = {'to' => '13065377760', 
           'from' => '13069881525', 
           'answer_url' => 'http://example.com/AnswerUrl',
           'answer_method' => 'GET',
           'hangup_url' => 'http://example.com/HangupUrl'
        }
        
response = $sms.make_call(params)