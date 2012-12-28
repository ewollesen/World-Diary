class SubjectsController < ApplicationController
  load_resource :find_by => :permalink
  authorize_resource


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
  end

  def update
    if @subject.update_attributes(params[:subject])
      redirect_to @subject, :notice => "Subject updated"
    else
      render :edit
    end
  end

end
