class AddFacebookLinkAndLocationAndUidAndOathTokenAndOauthExpiresAtAndImageAndFbUsernameAndBirthdateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_link, :string
    add_column :users, :location, :string
    add_column :users, :uid, :string
    add_column :users, :oath_token, :string
    add_column :users, :oauth_expires_at, :datetime
    add_column :users, :image, :string
    add_column :users, :fb_username, :string
    add_column :users, :birthdate, :datetime
  end
end
