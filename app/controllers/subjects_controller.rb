class SubjectsController < ApplicationController

  def create
    @subject = Subject.new(params[:subject])

    if @subject.save
      redirect_to @subject, notice: "Subject created"
    else
      render :new
    end
  end

  def destroy
    @subject = Subject.find_by_permalink!(params[:id])

    @subject.destroy
    redirect_to({action: "index"}, alert: "Subject destroyed")
  end

  def edit
    @subject = Subject.find_by_permalink!(params[:id])
  end

  def index
    @subjects = Subject.order("name ASC")
  end

  def new
    @subject = Subject.new(params[:subject])
  end

  def show
    @subject = Subject.find_by_permalink!(params[:id])
  end

  def update
    @subject = Subject.find_by_permalink!(params[:id])

    if @subject.update_attributes(params[:subject])
      redirect_to @subject, :notice => "Subject updated"
    else
      render :edit
    end
  end

end
