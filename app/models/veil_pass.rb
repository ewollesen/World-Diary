class VeilPass < ActiveRecord::Base
  belongs_to :subject, :touch => true
  belongs_to :user

  attr_accessible :user_id, :includes_attachments

  delegate :name, :to => :user, :prefix => true, :allow_nil => true
end
