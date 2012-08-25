class Users::RegistrationsController < Devise::RegistrationsController
  def create
    puts 'whoaa copied code'
    build_resource
    puts resource
    puts resource.valid?

    if resource.save
      puts 'it is saved'
      if resource.active_for_authentication?
        puts 'active'
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        # respond_with resource, :location => after_sign_up_path_for(resource)
        redirect_to home_confirmation_path :email => resource.email
      else
        puts 'oohhhhh'
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        # respond_with resource, :location => after_inactive_sign_up_path_for(resource)
        redirect_to home_confirmation_path :email => resource.email
      end
    else
      puts 'not saved'
      clean_up_passwords resource
      respond_with resource
    end
  end

  def new
    puts 'pleaseesesesesese'
    puts params
    super
  end
end
