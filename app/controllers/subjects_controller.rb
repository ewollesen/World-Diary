class SubjectsController < ApplicationController
  load_resource :find_by => :permalink
  authorize_resource
  around_filter :track, :only => :show


  def create
    if @subject.save
      redirect_to @subject, notice: "Subject created"
    else
      render :new
    end
  end

  def destroy
    @subject.destroy
    redirect_to({action: "index"}, alert: "Subject destroyed")
  end

  def edit
  end

  def index
    @subjects = @subjects.order("name ASC")
  end

  def new
  end

  def show
    abil = Ability.new(current_user)
    @attachments = @subject.attachments.accessible_by(abil)
    @veil_passes = @subject.veil_passes.accessible_by(abil)
  end

  def update
    if @subject.update_attributes(params[:subject])
      redirect_to @subject, :notice => "Subject updated"
    else
      render :edit
    end
  end


  protected

  NUM_RECENT_SUBJECTS = 9

  def track
    session[:recent_subjects] ||= []
    title = @subject.name
    url = request.fullpath
    time = Time.now

    yield

    session[:recent_subjects] =
      session[:recent_subjects].find_all {|t, u| u != url}.take(NUM_RECENT_SUBJECTS)
    session[:recent_subjects].unshift([title, url, time])
  end

end
