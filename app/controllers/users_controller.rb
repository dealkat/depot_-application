class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  def self.consumer

# The readkey and readsecret below are the values you get during registration

#OAuth::Consumer.new(“OmwO7wsjtYHjquu6bd6C4w”, “j1kZ6yzsqChkeQtToErUx2LnPQMsSPkXMkiy4F82sPA”,{ :site=>”http://twitter.com” })

end

def create

@request_token = UsersController.consumer.get_request_token(:oauth_callback => "www..")

session[:request_token] = @request_token.token

session[:request_token_secret] = @request_token.secret

# Send to twitter.com to authorize

redirect_to @request_token.authorize_url

return

end

Now this is an important part where you need to set the call back url Which u will define while you register your app at twitter OAuth site. Again add this to the UserController

def callback
@request_token = OAuth::RequestToken.new(UsersController.consumer,
session[:request_token],
session[:request_token_secret])
# Exchange the request token for an access token.
@access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
@response = UsersController.consumer.request(:get, ‘/account/verify_credentials.json’,
@access_token, { :scheme => :query_string })
case @response
when Net::HTTPSuccess
user_info = JSON.parse(@response.body)
unless user_info['screen_name']
flash[:notice] = “Authentication failed”
redirect_to :action => :index
return
end

# We have an authorized user, save the information to the database.
@user = User.new({ :screen_name => user_info['screen_name'],:token => @access_token.token,:secret => @access_token.secret })
@user.save!
# Redirect to the show page
redirect_to(@user)
else
RAILS_DEFAULT_LOGGER.error “Failed to get user info via OAuth”
# The user might have rejected this application. Or there was some other error during the request.
flash[:notice] = “Authentication failed”
redirect_to :action => :index
return
end
end
end
end

