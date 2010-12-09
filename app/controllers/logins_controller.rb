# This controller handles the login/logout function of the site.  
class LoginsController < ApplicationController
  layout "store"
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # render new.erb.html
    def new
#     redirect_back_or_default ('/')
  end

  def create
#    render :text => "Hi" and return false
    @user = User.authenticate(params[:login], params[:password])
    
#    render :text => @user.login and return false
    if @user
#      render :text=>@user.inspect and return false
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
#      logout_keeping_session!
      self.current_user = @user
#      handle_remember_cookie! new_cookie_flag
      flash[:notice] = "Logged in successfully"
      redirect_to :action => :welcome
      else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      flash[:notice] = 'login failed'
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

  def welcome
  @total_orders = Order.count
  end


protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
