class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from 'ActiveRecord::RecordNotFound', :with => :render_404 unless Rails.env.development?

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def render_404
    render :text => '404', :status => :not_found
  end

  def redirect_if_logged_out
    unless current_user
      flash[:alert] = "Don't do that."
      redirect_to root_path
    end
  end
end
