class TagsController < ApplicationController
  load_and_authorize_resource class: "ActsAsTaggableOn::Tag"

  def show
    abil = Ability.new(current_user || User.new)
    @subjects = Subject.tagged_with(@tag).accessible_by(abil)
  end

end
