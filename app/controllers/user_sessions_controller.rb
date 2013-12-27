class UserSessionsController < ApplicationController

  # GET /user_sessions
  def index
    redirect_to new_user_session_path
  end

  # GET login
  def new
    if current_user
      redirect_to root_path
    else   
      @user_session = UserSession.new
      respond_to do |format|
        format.html # new.html.erb
        format.xml { render :xml => @user_session }
      end
    end
  end

  # POST /user_sessions
  def create
    @user_session = UserSession.new(user_session_params)

    respond_to do |format|
      if @user_session.save
        format.html { redirect_to @user_session, notice: 'User session was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user_session }
      else
        format.html { render action: 'new' }
        format.json { render json: @user_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET logout
  def destroy
    @user_session = UserSession.find
    if @user_session
      @user_session.destroy
    end
    reset_session
    flash[:notice] = t("general.logout_successful")
    respond_to do |format|
      format.html { redirect_to "/" }
      format.xml { head :ok }
    end
  end

  # GET signup
  def signup
    @o_single = User.new

    if request.post?
      params[:user][:password_confirmation] = params[:user][:password]
      params[:user][:registration_key] = SecureRandom.hex(25)
      params[:user][:interval_time] = 180
      params[:user][:time_zone] = 'UTC'
      @o_single = User.new(user_params)

      respond_to do |format|
        if @o_single.save

          @o_single.role = Role.where(role_type: "user").first

          @user_session = UserSession.new
          @user_session.email = @o_single.email
          @user_session.password = params[:user][:password]

          if @user_session.save
            session[:user_id] = current_user.id
            session[:user_role] = current_user.role.role_type
            notice = t("general.successfully_registered")
          end
          format.html { redirect_to login_url, notice: notice }
          format.json { render action: 'show', status: :created, location: @o_single }
        else
          format.html { render action: 'signup' }
          format.json { render json: @o_single.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_session_params
      params[:user_session]
    end

    def user_params
      params.require(:user).permit!
    end
end
