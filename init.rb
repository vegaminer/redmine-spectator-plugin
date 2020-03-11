require 'redmine'
require_dependency 'application_controller'
class ApplicationController < ActionController::Base
  unloadable
  before_action :_enable_session_from_redmine_plugin
  alias_method :logout_user_without_spectator, :logout_user
  def logout_user
    session[:spectator] = nil
    logout_user_without_spectator
  end

  protected
  def _enable_session_from_redmine_plugin
    request = instance_variable_get(:@_request)

    Redmine::Plugin.send(:define_method, "spectator_id", proc {request.session[:spectator_id]})
  end
end

Redmine::Plugin.register :spectator do
  name 'Spectator plugin'
  author 'Alexey Pisarenko'
  description 'Plugin for logging as another user'
  version '0.0.2'
  url 'https://github.com/alpcrimea/redmine-spectator-plugin'
  author_url 'https://github.com/alpcrimea'
  menu :account_menu, :spectator, { :controller => 'spectator', :action => 'index' }, :caption => :change_user, :if => Proc.new { User.current.admin? || spectator_id }
end
