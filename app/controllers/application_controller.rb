class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from 'ActiveRecord::RecordNotFound', :with => :render_404 unless Rails.env.development?

  private
  def render_404
    render :text => '404', :status => :not_found
  end
end
