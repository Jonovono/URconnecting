@client = Twilio::REST::Client.new "ENTER", "ENTER"

@client.account.sms.messages.create(
  :from => '+14509000103',
  :to => 'PHONE',
  :body => 'boogie man!'
)