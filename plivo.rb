require 'plivo'
include Plivo

AUTH_ID = "ID"
AUTH_TOKEN = "TOKEN"


p = RestAPI.new(AUTH_ID, AUTH_TOKEN)


# Send SMS
params = {'src' => '13069881525', 
           'dst' => 'DIST', 
           'text' => 'Hi, message from Plivo this is pretty cool ',
           'type' => 'sms',
        }
response = p.send_message(params)

params = {'to' => 'DIST', 
           'from' => '13069881525', 
           'answer_url' => 'http://example.com/AnswerUrl',
           'answer_method' => 'GET',
           'hangup_url' => 'http://example.com/HangupUrl'
        }
        
response = $sms.make_call(params)