class HomesController < ApplicationController

  def show
    ab = Ability.new(current_user)

    @updated_subjects = Subject.accessible_by(ab).order("updated_at DESC").limit(18)
  end

end
