class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate params[:session][:email], params[:session][:password]

    if user
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination.'
      @title = 'Sign in'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
