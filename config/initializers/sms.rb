# $sms = Nexmo::Client.new('404e7d57', '721423dd')
# $sms = Twilio::REST::Client.new "AC1e4a4539b49cd425f80494be4fa8e1e8", "c70452279b06d887fba62ad41938bc92"
# include Plivo
# 
AUTH_ID = "MAYZAWY2Y4NTG2NTM3OW"
AUTH_TOKEN = "MTUwMjNhZTI3Y2RhMmM4YzcwNmM3ZDhkZmI3OGNh"


$sms = Plivo::RestAPI.new(AUTH_ID, AUTH_TOKEN)