Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "424425824260829", "a5327343c489a71e04a979ac2a8089c3", :scope => "user_birthday, user_relationships, user_education_history",
                                          :image_size => 'large'
end