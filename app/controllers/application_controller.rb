class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  before_filter do
    session[:recent_subjects] ||= []
    @recent_subjects = session[:recent_subjects].map do |id, time|
      [Subject.find(id), time]
    end
  end

end
