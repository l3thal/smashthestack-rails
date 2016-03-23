class WargamesController < ApplicationController
  before_filter :find_it, only: [:edit, :show, :update, :destroy]
  before_filter :authenticate_user!, only: [:edit, :update, :destroy] 
  before_filter :set_session, only: [:show]

  def index
    @wargames = Wargame.all
    session[:channel] = "#wargames"
    respond_with @wargames
  end

  def show
    respond_with @wargame
  end
 
  def edit
    redirect_to :back if !allowed
    respond_with @wargame 
  end
  
  def update
    @wargame.update_attributes params[:wargame]
    respond_with @wargame
  end
 
  def destroy
    @wargame.destroy
  end
  
  def irc
    session[:channel] = "##{params[:wargame_id]}"
    redirect_to irc_path
  end
  
  private
  def set_session
    check_status
    session[:channel] = "##{params[:id]}"
  end

  def find_it
    @wargame = Wargame.find_by_name(params[:id])
  end

  def check_status
    redirect_to "http://#{@wargame.id}.smashthestack.org:#{@wargame.http_port}" if @wargame.status == "online"
  end

  def allowed
    current_user.is?('leet')
  end
end
