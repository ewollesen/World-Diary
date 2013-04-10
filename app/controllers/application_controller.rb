class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  before_filter do
    session[:recent_subjects] ||= []
    @recent_subjects = session[:recent_subjects].inject([]) do |subjects, (id, time)|
      if subject = Subject.where(id: id).first
        subjects << [subject, time]
      else
        subjects
      end
    end
  end

end
