class VeilPass < ActiveRecord::Base
  belongs_to :subject
  belongs_to :user

  attr_accessible :user_id

  delegate :name, :to => :user, :prefix => true, :allow_nil => true
end
