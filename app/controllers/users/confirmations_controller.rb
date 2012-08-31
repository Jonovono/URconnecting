class Users::ConfirmationsController < Devise::ConfirmationsController
  def new
    super
  end

  def create
    super
  end
  
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    
    @user_id = params[:user_id]

    if resource.errors.empty?
      puts 'no errorss'
      set_flash_message(:notice, :confirmed) if is_navigational_format?
      
      sign_in(resource_name, resource)
      
      # respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
      respond_with_navigational(resource){ redirect_to user_steps_path :user_id => @user_id }
      
    elsif resource.errors.count == 1
      puts 'no errorss'
      set_flash_message(:notice, :confirmed) if is_navigational_format?
      
      sign_in(resource_name, resource)
      
      # respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
      respond_with_navigational(resource){ redirect_to user_steps_path :user_id => @user_id}
    else
      puts 'errrrrors'
      resource.errors.each do |e|
        puts e
      end
      puts resource.errors.count
      respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
    end
  end
end