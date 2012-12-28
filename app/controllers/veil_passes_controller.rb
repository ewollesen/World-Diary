class VeilPassesController < ApplicationController
  load_and_authorize_resource

  before_filter :authenticate_user!


  def index
    @veil_passes = @veil_passes.joins(:subject).order(subject: :name)
  end
end
