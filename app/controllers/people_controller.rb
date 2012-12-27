class PeopleController < ApplicationController

  def create
    @person = Person.new(params[:person])

    if @person.save
      redirect_to @person, :notice => "Person created"
    else
      render :new
    end
  end

  def destroy
    @person = Person.find_by_permalink!(params[:id])

    @person.destroy
    redirect_to :index, :notice => "Person destroyed"
  end

  def edit
    @person = Person.find_by_permalink!(params[:id])
  end

  def index
    @people = Person.order("name ASC")
  end

  def new
    @person = Person.new(params[:person])
  end

  def show
    @person = Person.find_by_permalink!(params[:id])
  end

  def update
    @person = Person.find_by_permalink!(params[:id])

    if @person.update_attributes(params[:person])
      redirect_to @person, :notice => "Person updated"
    else
      render :edit
    end
  end

end
