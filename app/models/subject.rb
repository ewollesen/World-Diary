class Subject < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  acts_as_commentable
  acts_as_taggable

  has_permalink

  validates :name, :uniqueness => true, :presence => true
  validates :permalink, :uniqueness => true, :presence => true
  validates :text, :presence => true

  class_attribute :specifier

  has_many :attachments, :dependent => :destroy
  accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => proc {|attributes| attributes["id"].blank? && attributes["attachment"].blank?}

  has_many :veil_passes, :dependent => :destroy
  accepts_nested_attributes_for :veil_passes, :allow_destroy => true, :reject_if => proc {|attributes| attributes["id"].blank? && attributes["user_id"].blank?}

  has_many :authorized_users, :through => :veil_passes, :source => :user

  before_save :update_vp_text, :if => :text_changed?
  before_save :update_anon_text, :if => :text_changed?


  def self.lookup(name, specifier=nil)
    s = where(name: name)
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

  def update_vp_text
    self.vp_text = DmStripper.strip(text, nil, true)
  end

  def update_anon_text
    self.anon_text = DmStripper.strip(text, nil, false)
  end

end
