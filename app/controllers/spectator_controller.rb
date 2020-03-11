class SpectatorController < ApplicationController
  unloadable
  before_action :require_login, :check_page_access

  def index
    @all_users = User.order('login').select{|u| u.active? }
  end

  def change_user
    session[:user_id] = params[:id]
	session[:tk] = User.find(params[:id]).generate_session_token
    session[:spectator_id]||=User.current.id
    redirect_to :action=> :index
  end

  def check_page_access
    render_403 unless User.current.admin? || session[:spectator_id]
  end

end
