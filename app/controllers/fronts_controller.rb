class FrontsController < ApplicationController
  before_filter :require_user, :only => [:change_password, :profile]

  def dashboard
    #@chat_messages = Message.find
    unless current_user
      redirect_to signup_url
    end
  end

  #forgot password
  def forgot_password
    @user = User.new
    if params[:user]
      if user = authenticate_email(params[:user][:email])
        new_pass = SecureRandom.hex(5)
        user.password = user.password_confirmation = new_pass
        user.save

        #options
        opts = { :username => user.fullname, :new_pass => new_pass }

        #subject
        subject = t("general.reset_password")

        #send mail
        UserMailer.forgot_password_confirmation(user.email, subject, opts).deliver

        @user_session = UserSession.find
        if @user_session
          @user_session.destroy
        end
        session[:user_id] = nil
        flash[:notice] = t("general.password_has_been_sent_to_your_email_address")
        redirect_to forgot_password_path
      else
        flash[:forgot_pass_error] = t("general.no_user_exists_for_provided_email_address")
        redirect_to :action => "forgot_password"
      end
    end
  end

  #change password
  def change_password
    @o_single = User.find(current_user.id)
    if params[:user]
      @o_single.password = params[:user][:password]
      @o_single.password_confirmation = params[:user][:password_confirmation]
      @o_single.password_required = true
      respond_to do |format|
        if @o_single.update_attributes(user_params)
          format.html { redirect_to change_password_url, notice: t("general.password_successfully_updated") }
          format.json { head :no_content }
        else
          format.html { render action: 'change_password' }
          format.json { render json: @o_single.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # signup user activation
  def user_activation
    if request.get?
      if params[:activation_key].present?
        @o_user = User.find(:first, :conditions => ["registration_key = ? AND is_active = ?", params[:activation_key], false])
        if @o_user
          @o_user.update(:is_active => true)          
          flash[:notice] = t("general.user_active_successfully")
          redirect_to root_url
        else
          flash[:notice] = t("general.already_activated")
        end
      end
    end
  end

  #profile
  def profile
    @o_single = User.find(current_user.id)
    if params[:user]
      respond_to do |format|
        if @o_single.update_attributes(user_params)
          format.html { redirect_to profile_url, notice: t("general.successfully_updated") }
          format.json { head :no_content }
        else
          format.html { render action: 'profile' }
          format.json { render json: @o_single.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit!
    end

end
