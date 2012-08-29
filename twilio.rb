@client = Twilio::REST::Client.new "AC1e4a4539b49cd425f80494be4fa8e1e8", "c70452279b06d887fba62ad41938bc92"

@client.account.sms.messages.create(
  :from => '+14509000103',
  :to => '13065377760',
  :body => 'boogie man!'
)