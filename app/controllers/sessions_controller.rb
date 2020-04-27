class SessionsController < ApplicationController

    def new
        render :new
    end

    def create
        @user = User.find_by_credentials(params[:user][:username], params[:user][:password])
        if @user.nil?
            flash.now[:errors] = ["Invalid username/password"]
            redirect_to cats_url
        else
            @user.reset_session_token
            session[:session_token] = @user.session_token
            redirect_to cats_url  #one more time, how do we know we are going to the index here?
        end
    end 

    def destroy
        current_user.reset_session_token #does this work?
        session[:session_token] = nil
        redirect_to new_session_url
    end



end