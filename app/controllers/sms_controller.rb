class SmsController < ApplicationController
  def index
    puts 'Incoming text message received'
    puts params
    puts params[:query]
  end
end
