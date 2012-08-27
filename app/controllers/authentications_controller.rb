class AuthenticationsController < ApplicationController
  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = current_user.authentications if current_user
  end

  # GET /authentications/1
  # GET /authentications/1.json
  def show
    @authentication = Authentication.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @authentication }
    end
  end

  # GET /authentications/new
  # GET /authentications/new.json
  def new
    @authentication = Authentication.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @authentication }
    end
  end

  # GET /authentications/1/edit
  def edit
    @authentication = Authentication.find(params[:id])
  end

  # POST /authentications
  # POST /authentications.json
  def create
    puts 'creating the auth'
    auth = request.env['omniauth.auth']
    puts auth
    puts 'pennnnnesss'
    puts env["omniauth.auth"]
    
    # current_user.authentications.first_or_create!(:provider => auth['provider'], :uid => auth['uid'])
    # current_user.add_authentication_values(env["omniauth.auth"])
    
    # user = User.from_omniauth(env["omniauth.auth"])
    puts 'kisthereauser'
    # user = User.from_omniauth(auth, current_user)
    if current_user
      current_user.add_authentication_values(auth)
      user = current_user
    else
      user = User.find_or_create_by_provider_and_uid(auth['provider'], auth['uid'])
      sign_in user
    end
    puts 'signintheuser'
    puts user
    session[:user_id] = user.id
    puts current_user
    
    
    flash[:notice] = "Good"
    redirect_to home_how_path
    # @authentication = Authentication.new(params[:authentication])
    # 
    # respond_to do |format|
    #   if @authentication.save
    #     format.html { redirect_to @authentication, notice: 'Authentication was successfully created.' }
    #     format.json { render json: @authentication, status: :created, location: @authentication }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @authentication.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PUT /authentications/1
  # PUT /authentications/1.json
  def update
    @authentication = Authentication.find(params[:id])

    respond_to do |format|
      if @authentication.update_attributes(params[:authentication])
        format.html { redirect_to @authentication, notice: 'Authentication was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @authentication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
