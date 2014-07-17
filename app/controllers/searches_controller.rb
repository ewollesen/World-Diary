class SearchesController < ApplicationController

  def create
    @search = Search.new(search_params).execute(current_user || User.new)

    render action: :show
  end

  def show
    @search = Search.new(search_params).execute(current_user || User.new)
  end


  protected

  def search_params
    params.require(:search).permit(:query)
  end
end
