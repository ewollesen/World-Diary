class VeilPassesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource


  def index
    @veil_passes = @veil_passes.joins(:subject).order(subject: :name)
  end
end
