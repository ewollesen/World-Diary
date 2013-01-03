class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = @users.order(:first_name, :last_name)
  end

end
