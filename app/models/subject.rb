class Subject < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  has_permalink

  validates :name, :uniqueness => true, :presence => true
  validates :permalink, :uniqueness => true, :presence => true
  validates :text, :presence => true

  attr_accessible :name, :text, :permalink, :dm_only

  class_attribute :specifier


  def self.lookup(name, specifier=nil)
    s = scoped
    s = s.where(:name => name)
    # if specifier && self.specifier
    #   s = s.where(:type => specifier_to_class(specifier))
    # end
    s.first
  end

  def to_param
    self.permalink
  end

  def url
    url_for(self)
  end


  # def self.specifier_to_class(specifier)
  #   self.specifier == specifier ? self.name : nil
  # end
end
