class AuthController < ApplicationController

  def login

    if request.post?

      user = User.authenticate(params[:name], params[:password])

      if user
        flash.now[:notice] = "Successful login"
        session[:user_id] = user.id
        redirect_to(:controller => "call", :action => "index")
      else
        flash.now[:alert] = "Invalid user/password combination"
      end
    end

    @layout_suppress_rtcc_js = true

  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")
  end

end
