class SearchesController < ApplicationController

  def create
    @search = Search.new(search_params).execute(current_user || User.new)

    render action: :show
  end


  protected

  def search_params
    params.require(:search).permit(:query)
  end
end
