class NotesController < ApplicationController
  load_resource :find_by => :permalink
  authorize_resource

  def create
    if @note.save
      redirect_to @note, notice: "Note created"
    else
      render :new
    end
  end

  def destroy
    @note.destroy
    redirect_to({action: "index"}, alert: "Note destroyed")
  end

  def index
    @notes = @notes.order("name ASC")
  end

  def update
    if @note.update(note_params)
      redirect_to @note, notice: "Note updated"
    else
      render :edit
    end
  end


  protected

  def note_params
    params
      .require(:note)
      .permit(:name, :text, :permalink, :dm_only)
  end

end
