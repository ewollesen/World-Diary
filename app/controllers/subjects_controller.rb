class SubjectsController < ApplicationController
  load_resource :find_by => :permalink
  authorize_resource
  after_filter :track, :only => :show


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
    if @subject.update(subject_params)
      redirect_to @subject, notice: "Subject updated"
    else
      render :edit
    end
  end


  protected

  NUM_RECENT_SUBJECTS = 9

  def track
    session[:recent_subjects] = session[:recent_subjects]
      .find_all {|id, time| id != @subject.id}
      .take(NUM_RECENT_SUBJECTS)
    session[:recent_subjects].unshift([@subject.id, Time.now])
  end


  def subject_params
    params
      .require(:subject)
      .permit(:name, :text, :permalink, :dm_only, :tag_list,
              {veil_passes_attributes: [:id,
                                        :subject_id,
                                        :user_id,
                                        :includes_attachments,
                                        :_destroy]},
              {attachments_attributes: [:id,
                                        :attachment,
                                        :remote_attachment_url,
                                        :attachment_cache,
                                        :caption,
                                        :dm_only,
                                        :_destroy]})
  end

end
