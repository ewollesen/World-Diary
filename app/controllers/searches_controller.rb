class SearchesController < ApplicationController

  def create
    @search = Search.new(params[:search]).execute(current_user || User.new)

    render action: :show
  end

end
