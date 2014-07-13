class VeilPass < ActiveRecord::Base
  belongs_to :subject, :touch => true
  belongs_to :user

  delegate :name, :to => :user, :prefix => true, :allow_nil => true
end
