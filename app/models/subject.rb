class Subject < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  has_permalink

  validates :name, :uniqueness => true, :presence => true
  validates :permalink, :uniqueness => true, :presence => true
  validates :text, :presence => true

  attr_accessible :name, :text, :permalink, :dm_only, :attachments_attributes, :veil_passes_attributes

  class_attribute :specifier

  has_many :attachments, :dependent => :destroy
  accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => proc {|attributes| attributes["attachment"].blank?}

  has_many :veil_passes, :dependent => :destroy
  accepts_nested_attributes_for :veil_passes, :allow_destroy => true, :reject_if => proc {|attributes| attributes["user_id"].blank?}

  has_many :authorized_users, :through => :veil_passes, :source => :user


  def self.lookup(name, specifier=nil)
    s = scoped
    s = s.where(:name => name)
    # if specifier && self.specifier
    #   s = s.where(:type => specifier_to_class(specifier))
    # end
    s.first || dummy(name)
  end

  def to_param
    self.permalink
  end

  def url
    new_record? ? new_subject_path(subject: {name: name}) : url_for(self)
  end


  # def self.specifier_to_class(specifier)
  #   self.specifier == specifier ? self.name : nil
  # end

  def authorized_user?(user)
    authorized_users.include?(user)
  end


  private

  def self.dummy(name)
    Subject.new(name: name)
  end
end
