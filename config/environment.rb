# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Urdating::Application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.gmail.com',
    :domain         => 'urconnecting.com',
    :port           => 587,
    :user_name      => 'contact@urconnecting.com',
    :password       => 'staller123',
    :authentication => :plain
}