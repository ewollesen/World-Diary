class PlacesController < ApplicationController

  def create
    @place = Place.new(params[:place])

    if @place.save
      redirect_to @place, :notice => "Place created"
    else
      render :new
    end
  end

  def destroy
    @place = Place.find_by_permalink!(params[:id])

    @place.destroy
    redirect_to :index, :notice => "Place destroyed"
  end

  def edit
    @place = Place.find_by_permalink!(params[:id])
  end

  def index
    @places = Place.order("name ASC")
  end

  def new
    @place = Place.new(params[:place])
  end

  def show
    @place = Place.find_by_permalink!(params[:id])
  end

  def update
    @place = Place.find_by_permalink!(params[:id])

    if @place.update_attributes(params[:place])
      redirect_to @place, :notice => "Place updated"
    else
      render :edit
    end
  end

end
